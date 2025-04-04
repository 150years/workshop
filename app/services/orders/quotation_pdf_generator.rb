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
        agreement_path = Rails.root.join('app/assets/texts/agreement.txt')
        agreement_text = File.read(agreement_path)
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
