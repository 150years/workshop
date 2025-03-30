# frozen_string_literal: true

Rails.application.config.action_view.field_error_proc = proc do |html_tag, _instance|
  # Use Nokogiri to parse and modify the HTML tag
  doc = Nokogiri::HTML::DocumentFragment.parse(html_tag)
  element = doc.children.first

  if element && %w[input select textarea].include?(element.name)
    element['class'] = [element['class'], 'is-invalid'].compact.join(' ')
    element.to_s.html_safe # rubocop:disable Rails/OutputSafety
  else
    html_tag
  end
end
