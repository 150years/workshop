# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def mobile_menu_button_class(path)
    "btn #{request.path.include?(path) ? 'btn--secondary' : 'btn--borderless'}"
  end

  def image_or_placeholder(image, height = 200, width = 200)
    if image.attached? && image.variable?
      begin
        image_tag image.variant(resize_to_fit: [height, width]).processed
      rescue ActiveStorage::FileNotFoundError
        content_tag(:div, '', class: 'skeleton rounded-lg bg-gray-200',
                              style: "height: #{height}px; width: #{width}px;")
      end
    else
      content_tag(:div, '', class: 'skeleton rounded-lg bg-gray-200', style: "height: #{height}px; width: #{width}px;")
    end
  end

  def app_version
    Rails.root.join('VERSION').read.strip
  rescue Errno::ENOENT
    'dev' # Fallback if the file is missing
  end

  def release_notes
    YAML.load_file(Rails.root.join('release_notes.yml'))['releases']
  end
end
