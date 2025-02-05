# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/new', type: :view do
  before(:each) do
    assign(:product, Product.new(
                       name: 'MyString',
                       width: 1,
                       height: 1,
                       comment: 'MyString'
                     ))
  end

  it 'renders new product form' do
    render

    assert_select 'form[action=?][method=?]', products_path, 'post' do
      assert_select 'input[name=?]', 'product[name]'

      assert_select 'input[name=?]', 'product[width]'

      assert_select 'input[name=?]', 'product[height]'

      assert_select 'input[name=?]', 'product[comment]'
    end
  end
end
