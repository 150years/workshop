# frozen_string_literal: true

pdf.text "Project: #{@order.name}"
pdf.text "Number: #{@version.quotation_number}"
pdf.text 'Color: Grey sahara' # (можно сделать авто из компонента, если одинаковый)

data = [['', 'รหัส', 'อลูมิเนียม', 'จำนวน', '', '', '', 'Total']]

@components.each do |component, quantities|
  row = []

  # Картинка
  if component.image.attached?
    tmp = Tempfile.new(['component_image', '.png'])
    tmp.binmode
    tmp.write(component.image.download)
    tmp.rewind
    row << { image: tmp.path, fit: [40, 40] }
  else
    row << ''
  end

  row << component.code
  row << component.name

  # Массив количеств по каждому продукту
  quantity_list = quantities.map(&:to_f)
  total = quantity_list.sum

  # Показать только первые 4 значения и потом Total
  row += quantity_list[0...4]
  row << total

  data << row
end

pdf.table(data, header: true, cell_style: { size: 9 })
