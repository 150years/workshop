# app/services/orders/quotation_pdf_generator.rb
class Orders::QuotationPdfGenerator
  def initialize(order, version)
    @order = order
    @version = version
  end

  def render
    Prawn::Document.new(page_size: 'A4', margin: [40, 40, 40, 40]) do |pdf|
      # Подключаем шрифт с поддержкой UTF-8
      pdf.font_families.update(
        "NotoSans" => {
          normal: Rails.root.join("app/assets/fonts/NotoSans-Regular.ttf"),
          bold:   Rails.root.join("app/assets/fonts/NotoSans-Bold.ttf"),
          italic: Rails.root.join("app/assets/fonts/NotoSans-Italic.ttf"),
          bold_italic: Rails.root.join("app/assets/fonts/NotoSans-BoldItalic.ttf"),
          normal: Rails.root.join("app/assets/fonts/NotoSansThai.ttf"),
        }
      ) 
      pdf.font("NotoSans")  # Устанавливаем активный шрифт
       
      # 🟦 1. Верхняя таблица с логотипом и текстом справа
        logo_path = Rails.root.join("app/assets/images/logo_docs.png")
        pdf.table([
          [
            { image: logo_path.to_s, fit: [100, 50], position: :left },
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
      pdf.text "Quotation / ใบเสนอราคา", size: 20, align: :center
      # 🟦 3. Таблица с датой и номером
      data = [
                [
                  { content: 
                    "<b>Project</b>: #{@order.name}
                    <b>Client:</b> #{@order.client.name}
                    <b>Address:</b> #{@order.client.address}
                    <b>Contact:</b> #{@order.client.phone} #{@order.client.email}
                    <b>Tax ID:</b> #{@order.client.tax_id}
                    ", align: :left },
                  { content: 
                    "<b>Date:</b> 02/04/2025
                    <b>Quotation No:</b> #{@version.quotation_number}
                    ", align: :right }
                ]
              ]
        pdf.table(
          data,
          width: pdf.bounds.width, 
          cell_style: { borders: [], size: 10, :inline_format => true }
        )        
              
      pdf.move_down 2

      data = [["#", "Image", "Product", "Size","Qty", "Unit Price", "Total"]]
      @version.products.each_with_index do |product, i|
        data << [
          i + 1,
          {:image => product.image},
          product.name.to_s,
          "#{product.width} x #{product.height}",
          product.quantity.to_i,
          price(product.price_cents.to_i),
          price(product.quantity.to_i * product.price_cents.to_i)
        ]
      end

      pdf.table(data, header: true, width: pdf.bounds.width, cell_style: { size: 10}) do
        row(0).font_style = :bold
        cells.padding = 8
        row(0).background_color = '354892'
        row(0).text_color = 'FFFFFF'
        
      end

      pdf.move_down 20
      pdf.text "Total: #{price(@version.total_amount_cents)}", size: 16, style: :bold
    end.render
  end

  private

  def price(cents)
    Money.new(cents.to_i, 'THB').format
  end
end
