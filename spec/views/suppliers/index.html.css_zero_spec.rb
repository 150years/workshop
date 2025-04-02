# frozen_string_literal: true

require 'rails_helper'
require 'pagy/extras/bootstrap' # если используешь Bootstrap, иначе не нужно

RSpec.describe 'suppliers/index', type: :view do
  before(:each) do
    assign(:search, Supplier.ransack)
    assign(:suppliers, [
             Supplier.create!(name: 'Name', contact_info: 'MyText'),
             Supplier.create!(name: 'Name', contact_info: 'MyText')
           ])
    assign(:pagy, Pagy.new(count: 2, page: 1)) # 💥 добавлено
  end

  it 'renders a list of suppliers' do
    render
    cell_selector = 'td'
    assert_select cell_selector, text: /Name/, count: 2
    assert_select cell_selector, text: /MyText/, count: 2
  end
end
