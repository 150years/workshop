# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DropdownHelper, type: :helper do
  describe '#dropdown_button' do
    let(:links) do
      [
        { name: 'Home', url: '/', data: { some: 'data' } },
        :separator,
        { name: 'Profile', url: '/profile', data: {} }
      ]
    end

    context 'when a button label is provided' do
      let(:button_label) { 'Options' }
      subject { helper.dropdown_button(links: links, button_label: button_label) }

      it 'wraps the button and menu in a div with popover data attributes' do
        expect(subject).to include('data-controller="popover"')
        expect(subject).to include('data-popover-placement-value="bottom-end"')
      end

      it 'renders a button with the provided label and correct classes' do
        expect(subject).to include('button')
        expect(subject).to include(button_label)
        expect(subject).to include('class="btn"')
      end
    end

    context 'when no button label is provided' do
      subject { helper.dropdown_button(links: links) }

      it 'renders a button with an image and hidden text' do
        expect(subject).to include('button')
        expect(subject).to include('ellipsis')
        expect(subject).to include('Open menu')
        expect(subject).to include('class="btn btn--borderless p-1"')
      end
    end

    it 'applies the given popover size and placement' do
      html = helper.dropdown_button(links: links, popover_size: '10rem', placement: 'top')

      expect(html).to include('data-popover-placement-value="top"')
      expect(html).to include('--popover-size: 10rem;')
    end

    it 'renders the dropdown menu with the provided links' do
      html = helper.dropdown_button(links: links)

      expect(html).to include('class="popover"')
      expect(html).to include('id="menu"')
      expect(html).to include('href="/"')
      expect(html).to include('href="/profile"')
    end
  end

  describe 'dropdown_menu_item (private)' do
    context 'when the item is a separator' do
      it 'returns an <hr> element with the correct attributes' do
        html = helper.send(:dropdown_menu_item, :separator)
        expect(html).to include('<hr')
        expect(html).to include('class="menu__separator"')
        expect(html).to include('role="separator"')
      end
    end

    context 'when the item is a normal link' do
      let(:item) { { name: 'Dashboard', url: '/dashboard', data: { foo: 'bar' } } }
      it 'returns a link with the proper attributes and classes' do
        html = helper.send(:dropdown_menu_item, item)
        expect(html).to include('<a')
        expect(html).to include('Dashboard')
        expect(html).to include('href="/dashboard"')
        expect(html).to include('class="btn menu__item"')
        expect(html).to include('data-foo="bar"')
        expect(html).to include('data-menu-target="item"')
        expect(html).to include('role="menuitem"')
      end
    end
  end
end
