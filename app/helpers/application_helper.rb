# frozen_string_literal: true

module ApplicationHelper
  def mobile_menu_button_class(path)
    "btn #{request.path.include?(path) ? 'btn--secondary' : 'btn--borderless'}"
  end
end
