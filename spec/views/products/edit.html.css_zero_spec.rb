# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/edit', type: :view do
  let(:product) do
    Product.create!(
      name: 'MyString',
      width: 1,
      height: 1,
      comment: 'MyString'
    )
  end

  before(:each) do
    assign(:product, product)
  end

  it 'renders the edit product form' do
    render

    assert_select 'form[action=?][method=?]', product_path(product), 'post' do
      assert_select 'input[name=?]', 'product[name]'

      assert_select 'input[name=?]', 'product[width]'

      assert_select 'input[name=?]', 'product[height]'

      assert_select 'input[name=?]', 'product[comment]'
    end
  end
end
