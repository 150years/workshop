# frozen_string_literal: true

module ComponentsHelper
  def image_or_placeholder(image, height = 200, width = 200)
    if image.attached?
      image_tag image.variant(resize_to_fit: [height, width]).processed
    else
      content_tag(:div, '', class: 'skeleton rounded-lg', style: "height: #{height}px; width: #{width}px;")
    end
  end
end
