# frozen_string_literal: true

# app/services/orders/quotation_pdf_generator.rb
module Orders
  class QuotationPdfGenerator
    def initialize(order, version)
      @order = order
      @version = version
    end

    def render
      Prawn::Document.new(page_size: 'A4', margin: [40, 40, 40, 40]) do |pdf|
        # Подключаем шрифт с поддержкой UTF-8
        pdf.font_families.update(
          'NotoSansThai' => {
            normal: Rails.root.join('app/assets/fonts/NotoSansThai-Regular.ttf'),
            bold: Rails.root.join('app/assets/fonts/NotoSansThai.ttf') # если есть
          }
        )
        pdf.font('NotoSansThai')

        # 🟦 1. Верхняя таблица с логотипом и текстом справа
        logo_path = Rails.root.join('app/assets/images/logo_docs.png')
        pdf.table([
                    [
                      { image: logo_path.to_s, fit: [200, 50], position: :left },
                      {
                        content: "THAI GLAZING CO., LTD (HEAD OFFICE)
              บริษัท ไทย กลาสซิ่ง จำกัด (สำนักงานใหญ่)
              Address 102/183 Moo 5, T. Rasada A. Muang Phuket 83000
              Phone: 0902993590, email: office@thaiglazing.coms
              Tax ID: 0835565015301",
                        align: :right,
                        size: 9
                      }
                    ]
                  ], cell_style: { borders: [], padding: [0, 0, 0, 0] }, width: pdf.bounds.width)
        pdf.move_down 20

        # 🟦 2. Заголовок "Quotation"
        pdf.text 'Quotation / ใบเสนอราคา',
                 size: 20,
                 align: :center

        # 🟦 3. Таблица с датой и номером
        data = [
          [
            {
              content:
                "<b>Project</b>: #{@order.name}
                <b>Client:</b> #{@order.client.name}
                <b>Address:</b> #{@order.client.address}
                <b>Contact:</b> #{@order.client.phone} #{@order.client.email}
                <b>Tax ID:</b> #{@order.client.tax_id}
                ",
              align: :left
            },
            {
              content:
                "<b>Date:</b> 02/04/2025
                <b>Quotation No:</b> #{@version.quotation_number}
                ",
              align: :right
            }
          ]
        ]
        pdf.table(
          data,
          width: pdf.bounds.width,
          cell_style: { borders: [], size: 10, inline_format: true }
        )
        pdf.move_down 2
        data = [['#', 'Image', 'Product', 'Qty', 'Unit Price', 'Total']]
        image_files = []
        grand_total_cents = 0
        @version.products.each_with_index do |product, i|
          image_cell = ''

          if product.image.attached?
            image_file = Tempfile.new(['product_image', '.png'])
            image_file.binmode
            image_file.write(product.image.download)
            image_file.rewind
            image_files << image_file
            image_cell = { image: image_file.path, fit: [100, 150] }
          end

          product_details = ''
          product.product_components.each do |component|
            product_details += "#{component.component.category.titleize}: #{component.component.color}\n"
          end

          line_total = product.quantity.to_i * product.price_cents.to_i
          grand_total_cents += line_total

          data << [
            i + 1,
            image_cell,
            "#{product.name}\n#{product_details}#{product.width} x H#{product.height}",
            product.quantity.to_i,
            price(product.price_cents.to_i),
            price(product.quantity.to_i * product.price_cents.to_i)
          ]
        end
        # 1. Вычисляем total_amount
        subtotal = @version.total_amount_cents.to_i

        # 2. Сумма скидки
        discount =
          if @version.respond_to?(:discount_cents) && @version.discount_cents.present?
            @version.discount_cents.to_i
          else
            0
          end

        # 3. Вычисляем withholding tax от стоимости работ
        labor_total_cents = @version.products.sum do |product|
          product.product_components.includes(:component).select do |pc|
            pc.component.name.to_s.downcase.include?('labor') ||
              pc.component.code.to_s.downcase.include?('labor')
          end.sum { |pc| pc.quantity.to_i * pc.component.price.to_i }
        end

        withholding_tax_cents = (labor_total_cents * 0.03).round

        # 4. Вычисляем VAT и Grand Total
        vat = ((subtotal - discount) * 0.07).to_i
        grand_total = subtotal - discount + vat - withholding_tax_cents
        summary_left = "<b>Total:</b>\n<b>Discount:</b>\n<b>Withholding tax (3% labor):</b>\n<b>Labor:</b>\n<b>Labor - WT:</b>\n<b>Material:</b>\n<b>VAT (7%):</b>\n<b>Grand Total:</b>"
        summary_right = [
          price(subtotal),
          price(discount),
          price(withholding_tax_cents),
          price(labor_total_cents),
          price(labor_total_cents - withholding_tax_cents),
          price(subtotal - labor_total_cents),
          price(vat),
          price(grand_total)
        ].join("\n")
        # Добавляем строку в таблицу
        data.size
        data << [
          { content: summary_left, align: :right, colspan: 5, inline_format: true },
          { content: summary_right, align: :left, inline_format: true }
        ]
        pdf.table(data,
                  header: true,
                  width: pdf.bounds.width,
                  column_widths: {
                    0 => 10, # #
                    1 => 110, # Image
                    5 => 65 # Total
                  },
                  cell_style: { size: 9, inline_format: true }) do |t|
          t.row(0).font_style = :bold
          t.row(0).background_color = '354892'
          t.row(-1).background_color = '354892'
          t.row(0).text_color = 'FFFFFF'
          t.row(-1).text_color = 'FFFFFF'
          t.cells.padding = 6
        end
        # 🟡 Determine payment plan
        payment_rows = []
        if grand_total < 30_000_00 # в центах
          payment_rows << [
            '100%  Deposit upon confirmatinon to order material / เมื่อยืนยันการสั่งซื้อวัสดุ',
            price(grand_total)
          ]
        elsif grand_total > 100_000_00 # в центах
          payment_rows << [
            '50% Deposit upon confirmation to order material / เมื่อยืนยันการสั่งซื้อวัสดุ',
            price(labor_total_cents * 0.5),
            price((labor_total_cents - withholding_tax_cents) * 0.5),
            price(grand_total * 0.5),
            price((labor_total_cents + labor_total_cents + grand_total) * 0.5)
          ]
          payment_rows << [
            '40% Products ready for installation / สินค้าพร้อมติดตั้ง',
            price(labor_total_cents * 0.4),
            price((labor_total_cents - withholding_tax_cents) * 0.4),
            price(grand_total * 0.4),
            price((labor_total_cents + labor_total_cents + grand_total) * 0.4)
          ]
          payment_rows << [
            '10% Upon completion of work / เมื่องานเสร็จเรียบร้อย',
            price(labor_total_cents * 0.4),
            price((labor_total_cents - withholding_tax_cents) * 0.1),
            price(grand_total * 0.1),
            price((labor_total_cents + labor_total_cents + grand_total) * 0.1)
          ] else
              payment_rows << [
                '50%  Deposit upon confirmatinon to order material / เมื่อยืนยันการสั่งซื้อวัสดุ',
                price(grand_total * 0.5)
              ]
              payment_rows << [
                '50%  Products ready for installation / สินค้าพร้อมติดตั้ง',
                price(grand_total * 0.5)
              ]
        end

        # 🔵 Рендерим таблицу
        pdf.move_down 20
        pdf.text '<b>Payment / กำหนดการชำระเงิน</b>', size: 12, inline_format: true
        pdf.table(
          payment_rows,
          header: true,
          width: pdf.bounds.width,
          cell_style: { borders: [], size: 9, inline_format: true }
        ) do
          row(0).font_style = :bold
          cells.padding = 6
        end
        pdf.move_down 20
        agreement_text = "<b>Agreement / ข้อตกลง</b>
                  1. Size may change according to the actual job site / ขนาดอาจเปลี่ยนแปลงตามหน้างานจริง.
                  2. The product images shown are for illustration purposes only and may not be an exact representation of the product. Actual product may vary due to product enhancement / ภาพสินค้าที่แสดงเป็นเพียงภาพร่างประกอบเบื้องต้นเท่านั้น ผลิตภัณฑ์จริงอาจแตกต่างกันไป
                  3. Not included in quotation if not specified separately: preparing the workplace, concrete work, steel support work, wall painting after installation, electricity and water expenses, transportation of materials to high-rise buildings in the case there is no elevator. / ไม่รวมในใบเสนอราคาหากไม่ได้ระบุแยก ได้แก่ การเตรียมสถานที่ งานคอนกรีต งานรองรับเหล็ก งานทาสีผนังหลังติดตั้ง ค่าไฟฟ้าและค่าน้ำ ค่าขนส่งวัสดุขึ้นอาคารสูง กรณีไม่มีลิฟต์
                  4. Warranty period for installation work is 1 year from the date of handover of works (see warranty condition below) / ระยะเวลารับประกันสำหรับงานติดตั้งคือ 1 ปีนับจากวันที่ส่งมอบงานเสร็จ
                  5. Quotation is valid for 15 days after that price may change / ใบเสนอราคาเบื้องต้นยืนราคา - 15 วัน หลังจาก 15 วัน ราคาอาจมีการเปลี่ยนแปลง

                  <b>Payment & installation terms / เงื่อนไขการชำระเงินและการติดตั้ง</b>
                  1. Deposit is non-refundable in any cases / มัดจำไม่สามารถคืนได้ในทุก ๆ กรณี
                  2. Material delivery time after receiving deposit and final measurements max 30 days if not specified otherwise / หากไม่มีการระบุอื่นได วันที่ส่งของนับจากจากได้รับ มัดจำและวัดพื้นที่หน้างานที่พร้อมติดตั้งแล้ว สูงสุดไม่เกิน 30 วัน
                  3. Installation must be completed within 30 days after receiving the 2nd payment if not specified otherwise / หากไม่มีการระบุอื่นได การติดตั้งต้องเสร็จสิ้นภายใน 30 วันหลังได้รับการชำระเงินครั้งที่ 2
                  4. Any delay in payment following the initial deposit will be considered as a cancellation of the agreement / หากเลยกำหนดชำระเงินทางบริษัทฯขอสงวนสิทธิในการยกเลิกการสังซื้อ
                  5. Any delay in installation may be claimed as damages by the Client, but the claim cannot exceed the value of the installation payment / ความล่าช้าของการส่งของทีเกิดจากบริษัทฯจะต้องแจ้งลูกค้าทราบล่วงหน้า และลูกค้าสามารถเรียกร้องสิทธิค่าเสียหายได้แต่ไม่เกินยอดที่ชำระแล้วเท่านั้น
                  6. The installation time can be re-scheduled if there are any changes after the installation confirmation / กรณีเปลี่ยนแปลงแบบหลังจากสั่งซื้อ มีผลต่อระยะเวลาส่งของที่กำหนดไว้

                  <b>Warranty conditions / เงื่อนไขการรับประกัน
                  1. Warranty Period: Company provides warranty for a period of one (1) year from the date of installation and signing of handover document by the Client./ระยะเวลาการรับประกัน: บริษัทให้การรับประกันเป็นระยะเวลาหนึ่ง (1) ปีนับจากวันที่ติดตั้งและลงนามในเอกสารการส่งมอบโดยลูกค้า
                  2. Scope of Warranty: Warranty covers any defects or malfunctions in products and installation work supplied under this quotation under normal use and service. During the warranty period, company will repair or replace, at its discretion, any defective parts at no additional cost to the Client.ขอบเขตการรับประกัน: การรับประกันครอบคลุมถึงข้อบกพร่องหรือการทำงานผิดปกติใดๆ ในผลิตภัณฑ์และงานติดตั้งที่ให้มาภายใต้ใบเสนอราคานี้ภายใต้การใช้งานและบริการตามปกติ ในช่วงระยะเวลาการรับประกัน บริษัทจะซ่อมแซมหรือเปลี่ยนชิ้นส่วนที่ชำรุดใดๆ โดยไม่มีค่าใช้จ่ายเพิ่มเติมแก่ลูกค้าตามดุลยพินิจของบริษัท
                  3. Warranty Exclusions/ข้อยกเว้นการรับประกัน:
                  This warranty does not cover damages resulting from การรับประกันนี้ไม่ครอบคลุมถึงความเสียหายที่เกิดจาก:
                  - Mechanical damage to the profile, fittings, glasses and mosquito nets that was not recorded in the handover document. ความเสียหายทางกลต่อโปรไฟล์ อุปกรณ์ แว่นตา และมุ้งที่ไม่ได้บันทึกไว้ในเอกสารการส่งมอบ
                  - Improper installation not performed by company or its authorized agents.การติดตั้งที่ไม่เหมาะสมไม่ได้ดำเนินการโดยบริษัทหรือตัวแทนที่ได้รับอนุญาต
                  - Unauthorized alterations or modifications. การเปลี่ยนแปลงหรือแก้ไขโดยไม่ได้รับอนุญาต
                  - Misuse, abuse, or neglect.การใช้ในทางที่ผิดการละเมิดหรือการละเลย
                  - Normal wear and tear.มีริ้วรอยตามการใช้งานปกติ
                  - Environmental and natural disasters, including but not limited to, fire, flood, earthquakes, and extreme weather conditions.ภัยพิบัติด้านสิ่งแวดล้อมและธรรมชาติ รวมถึงแต่ไม่จำกัดเพียง ไฟไหม้ น้ำท่วม แผ่นดินไหว และสภาพอากาศที่รุนแรง
                  4. Warranty Claims: In the event of a defect, the Client must notify Company in writing within 3 days of discovering the defect. Company will then arrange an inspection and subsequent repair/replacement as necessary.การเรียกร้องการรับประกัน: ในกรณีที่มีข้อบกพร่อง ลูกค้าจะต้องแจ้งให้บริษัททราบเป็นลายลักษณ์อักษรภายใน 3 วันหลังจากพบข้อบกพร่อง จากนั้นบริษัทจะจัดให้มีการตรวจสอบและซ่อมแซม/เปลี่ยนใหม่ในภายหลังตามความจำเป็น
                  5. Limitation of Liability: Under no circumstances shall Company be liable for any incidental, indirect, special, or consequential damages arising out of or in connection with the aluminum products provided. The liability of Company under this warranty shall in no event exceed the original purchase price of the defective product./การจำกัดความรับผิด: ไม่ว่าในสถานการณ์ใดก็ตาม บริษัทจะไม่รับผิดชอบต่อความเสียหายโดยบังเอิญ โดยอ้อม พิเศษ หรือเป็นผลสืบเนื่องใดๆ ที่เกิดขึ้นจากหรือเกี่ยวข้องกับผลิตภัณฑ์อะลูมิเนียมที่จัดให้ ความรับผิดของบริษัทภายใต้การรับประกันนี้จะต้องไม่เกินราคาซื้อเดิมของผลิตภัณฑ์ที่มีข้อบกพร่อง
                  4. Warranty Claims: In the event of a defect, the Client must notify Company in writing within 3 days of discovering the defect. Company will then arrange an inspection and subsequent repair/replacement as necessary.การเรียกร้องการรับประกัน: ในกรณีที่มีข้อบกพร่อง ลูกค้าจะต้องแจ้งให้บริษัททราบเป็นลายลักษณ์อักษรภายใน 3 วันหลังจากพบข้อบกพร่อง จากนั้นบริษัทจะจัดให้มีการตรวจสอบและซ่อมแซม/เปลี่ยนใหม่ในภายหลังตามความจำเป็น
                  5. Limitation of Liability: Under no circumstances shall Company be liable for any incidental, indirect, special, or consequential damages arising out of or in connection with the aluminum products provided. The liability of Company under this warranty shall in no event exceed the original purchase price of the defective product./การจำกัดความรับผิด: ไม่ว่าในสถานการณ์ใดก็ตาม บริษัทจะไม่รับผิดชอบต่อความเสียหายโดยบังเอิญ โดยอ้อม พิเศษ หรือเป็นผลสืบเนื่องใดๆ ที่เกิดขึ้นจากหรือเกี่ยวข้องกับผลิตภัณฑ์อะลูมิเนียมที่จัดให้ ความรับผิดของบริษัทภายใต้การรับประกันนี้จะต้องไม่เกินราคาซื้อเดิมของผลิตภัณฑ์ที่มีข้อบกพร่อง

                  <b>Payment method / ช่องทางการชำระเงิน</b>
                  "
        pdf.text agreement_text.strip, size: 8, inline_format: true

        pdf.text '<b>Payment method / ช่องทางการชำระเงิน</b>', size: 12, inline_format: true
        payment_data = [
          [
            { image: Rails.root.join('app/assets/images/kbank_logo.png').to_s, fit: [200, 64] },
            [
              '<b>Bank / ธนาคาร:</b> Kasikorn bank (ธนาคารกสิกรไทย)',
              '<b>Account No. / เลขที่บัญชี:</b> 137-342-6829',
              '<b>Account Name / ชื่อบัญชี:</b> Thai Glazing Co., Ltd'
            ].join("\n")
          ]
        ]

        pdf.table(
          payment_data,
          cell_style: {
            borders: %i[top bottom left right],
            size: 9,
            inline_format: true
          },
          width: pdf.bounds.width,
          column_widths: { 0 => 200 }
        )

        # 🔻 Таблица подписей с равными колонками
        signature_data = [
          ['Quoted by', 'Check by', 'Authorized by', 'Customer Confirmation'],
          ['( Intira )', '( ____________________ )', '( ____________________ )', '( ____________________ )'],
          ["Date #{Time.zone.today.strftime('%d/%m/%y')}", 'Date ___/___/___', 'Date ___/___/___', 'Date ___/___/___']
        ]

        pdf.table(signature_data,
                  cell_style: { borders: [], align: :center, size: 9 },
                  width: pdf.bounds.width) # 🔸 растягивает равномерно по ширине
      end.render
    end

    private

    def price(cents)
      "฿ #{Money.new(cents.to_i, 'THB').format(symbol: false)}"
    end
  end
end
