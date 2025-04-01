# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'materials/edit', type: :view do
  let(:material) do
    Material.create!(
      name: 'MyString',
      price: 1.5,
      supplier: nil,
      code: 'MyString'
    )
  end

  before(:each) do
    assign(:material, material)
  end

  it 'renders the edit material form' do
    render

    assert_select 'form[action=?][method=?]', material_path(material), 'post' do
      assert_select 'input[name=?]', 'material[name]'

      assert_select 'input[name=?]', 'material[price]'

      assert_select 'input[name=?]', 'material[supplier_id]'

      assert_select 'input[name=?]', 'material[code]'
    end
  end
end
