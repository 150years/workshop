class ComponentOrderPdf
  include Prawn::View

  def initialize(order, version)
    @order = order
    @version = version
    font_families.update('DejaVuSans' => {
                           normal: Rails.root.join('app/assets/fonts/DejaVuSans.ttf'),
                           bold: Rails.root.join('app/assets/fonts/DejaVuSans-Bold.ttf')
                         })
    font 'DejaVuSans'
    header
    table_content
  end

  def header
    text 'Components Order', size: 20, style: :bold
    move_down 10
    text "Order ##{@order.id} - #{@order.name}", size: 14
    text "Quotation Number: #{@version.full_quotation_number}", size: 12
  end

  def table_content
    move_down 20
    data = [%w[Code Name Color Qty Supplier]]

    @version.products.includes(product_components: :component).each do |product|
      product.product_components.each do |pc|
        component = pc.component
        data << [
          component.code,
          component.name,
          component.color,
          pc.quantity * (product.quantity || 1).to_f,
          component.supplier&.name
        ]
      end
    end

    table(data, header: true)
  end
end
