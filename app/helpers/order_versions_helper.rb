# frozen_string_literal: true

module OrderVersionsHelper
  def order_version_tabs(order_versions)
    return if order_versions.blank?

    buttons = order_versions_buttons(order_versions)

    tabs = order_versions_tabs(order_versions)

    content_tag(:div, safe_join(buttons), class: 'tabs__list mbe-4',
                                          data: { action: 'keydown.left->tabs#prev keydown.right->tabs#next' },
                                          role: 'tablist') + safe_join(tabs)
  end

  private

  def order_versions_buttons(order_versions)
    order_versions.map do |order_version|
      date = order_version.created_at.strftime('%d-%m-%Y')
      tag.button(date,
                 type: 'button',
                 id: "trigger_#{order_version.id}",
                 class: 'btn btn--tab',
                 data: { 'tabs-target': 'button', action: 'tabs#select' },
                 role: 'tab',
                 'aria-controls': dom_id(order_version))
    end
  end

  def order_versions_tabs(order_versions)
    order_versions.map do |order_version|
      turbo_frame_tag order_version, src: order_version_path(order_version.order_id, order_version.id),
                                     data: { 'tabs-target': 'tab' },
                                     class: 'mt-6',
                                     role: 'tabpanel',
                                     'aria-labelledby': "trigger_#{order_version.id}",
                                     loading: 'lazy' do
        <<~HTML.html_safe
          <div class="flex items-center gap">
            <div class="flex flex-col gap w-full">
              <div class="skeleton" style="height: var(--size-4); width: 800px;"></div>
              <div class="skeleton" style="height: var(--size-4); width: 800px;"></div>
              <div class="skeleton" style="height: var(--size-4); width: 800px;"></div>
              <div class="skeleton" style="height: var(--size-4); width: 800px;"></div>
              <div class="skeleton" style="height: var(--size-4); width: 800px;"></div>
              <div class="skeleton" style="height: var(--size-4); width: 800px;"></div>
            </div>
          </div>
        HTML
      end
    end
  end
end
