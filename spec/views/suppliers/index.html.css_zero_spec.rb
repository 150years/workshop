# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'suppliers/index', type: :view do
  before(:each) do
    assign(:suppliers, [
             Supplier.create!(
               name: 'Name',
               contact_info: 'MyText'
             ),
             Supplier.create!(
               name: 'Name',
               contact_info: 'MyText'
             )
           ])
  end

  it 'renders a list of suppliers' do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new('Name'), count: 2
    assert_select cell_selector, text: Regexp.new('MyText'), count: 2
  end
end
