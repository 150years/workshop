# frozen_string_literal: true

class ComponentsOrderPdfGenerator
  def initialize(order, version, products, category)
    @order = order
    @version = version
    @products = products
    @category = category
  end

  def render
    Prawn::Document.new(page_size: 'A4') do |pdf|
      pdf.text "Components Order - #{@category.capitalize}", size: 18, style: :bold
      pdf.move_down 10

      table_data = [%w[Image Code Color Name Quantity]]

      @products.each do |product|
        c = product.component
        table_data << ['', c.code, c.color, c.name, product.quantity.to_s]
      end

      pdf.table(table_data, header: true, row_colors: %w[F0F0F0 FFFFFF])
    end.render
  end
end
