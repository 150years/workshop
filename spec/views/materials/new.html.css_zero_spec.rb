# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'materials/new', type: :view do
  before(:each) do
    assign(:material, Material.new(
                        name: 'MyString',
                        price: 1.5,
                        supplier: nil,
                        code: 'MyString'
                      ))
  end

  it 'renders new material form' do
    render

    assert_select 'form[action=?][method=?]', materials_path, 'post' do
      assert_select 'input[name=?]', 'material[name]'

      assert_select 'input[name=?]', 'material[price]'

      assert_select 'input[name=?]', 'material[supplier_id]'

      assert_select 'input[name=?]', 'material[code]'
    end
  end
end
