# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/index', type: :view do
  before(:each) do
    assign(:products, [
             Product.create!(
               name: 'Name',
               width: 2,
               height: 3,
               comment: 'Comment'
             ),
             Product.create!(
               name: 'Name',
               width: 2,
               height: 3,
               comment: 'Comment'
             )
           ])
  end

  it 'renders a list of products' do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new('Name'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Comment'.to_s), count: 2
  end
end
