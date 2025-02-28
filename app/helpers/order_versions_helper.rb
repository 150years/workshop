# frozen_string_literal: true

module OrderVersionsHelper
  def order_version_tabs(order_versions)
    return if order_versions.blank?

    buttons = order_versions_buttons(order_versions)

    tabs = order_versions_tabs(order_versions)

    content_tag(:div, safe_join(buttons), class: 'tabs__list',
                                          data: { action: 'keydown.left->tabs#prev keydown.right->tabs#next' },
                                          role: 'tablist') + safe_join(tabs)
  end

  private

  def order_versions_buttons(order_versions)
    order_versions.map do |version|
      date = version.created_at.strftime('%d-%m-%Y')
      tag.button(date,
                 type: 'button',
                 id: "trigger_#{version.id}",
                 class: 'btn btn--tab',
                 data: { 'tabs-target': 'button', action: 'tabs#select' },
                 role: 'tab',
                 'aria-controls': "tab_#{version.id}")
    end
  end

  def order_versions_tabs(order_versions)
    order_versions.map do |version|
      content_tag(:div, "Version #{version.id} details",
                  hidden: true,
                  id: "tab_#{version.id}",
                  data: { 'tabs-target': 'tab' },
                  role: 'tabpanel',
                  'aria-labelledby': "trigger_#{version.id}")
    end
  end
end
