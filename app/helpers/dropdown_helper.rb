# frozen_string_literal: true

module DropdownHelper
  def dropdown_button(links:, button_label: nil, popover_size: '8rem', placement: 'bottom-end')
    content_tag :div, id: 'dropdown', data: { controller: 'popover', 'popover-placement-value': placement } do
      safe_join([dropdown_button_html(button_label), dropdown_menu_html(links, popover_size)])
    end
  end

  private

  def dropdown_button_html(button_label)
    common_attrs = {
      type: 'button',
      id: 'menu_button',
      data: { popover_target: 'button', action: 'popover#toggle' },
      aria: { haspopup: true, controls: 'menu' }
    }

    if button_label.present?
      button_tag(button_label, **common_attrs, class: 'btn')
    else
      button_tag(**common_attrs, class: 'btn btn--borderless p-1') do
        image_tag('ellipsis.svg', size: 16, aria: { hidden: true }) +
          content_tag(:span, 'Open menu', class: 'sr-only')
      end
    end
  end

  def dropdown_menu_html(links, popover_size)
    content_tag :div, popover: '', class: 'popover', style: "--popover-size: #{popover_size};",
                      data: { popover_target: 'menu' } do
      content_tag :div, id: 'menu', class: 'menu',
                        data: { controller: 'menu', action: 'keydown.up->menu#prev keydown.down->menu#next' },
                        role: 'menu', 'aria-labelledby': 'menu_button' do
        safe_join(links.map { |item| dropdown_menu_item(item) })
      end
    end
  end

  def dropdown_menu_item(item)
    return tag.hr class: 'menu__separator', role: 'separator' if item == :separator

    link_to item[:name], item[:url], class: 'btn menu__item', data: item[:data].merge(menu_target: 'item'),
                                     role: 'menuitem'
  end
end
