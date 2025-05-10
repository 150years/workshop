# frozen_string_literal: true

require 'rails_helper'
require 'pagy/extras/bootstrap' # если используешь Bootstrap, иначе не нужно

RSpec.describe 'suppliers/index', type: :view do
  before(:each) do
    assign(:search, Supplier.ransack)
    assign(:suppliers, [
             create(:supplier, name: 'Name', contact_info: 'MyText', email: 'test1@example.com'),
             create(:supplier, name: 'Name 2', contact_info: 'Other info', email: 'test2@example.com')
           ])
    assign(:pagy, Pagy.new(count: 2, page: 1)) # 💥 добавлено
  end

  it 'renders a list of suppliers' do
    render
    cell_selector = 'td'
    assert_select cell_selector, text: /Name/, count: 2
    assert_select cell_selector, text: /MyText/, count: 1
  end
end
