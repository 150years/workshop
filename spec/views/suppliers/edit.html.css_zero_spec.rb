# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'suppliers/edit', type: :view do
  let(:supplier) do
    Supplier.create!(
      name: 'MyString',
      contact_info: 'MyText'
    )
  end

  before(:each) do
    assign(:supplier, supplier)
  end

  it 'renders the edit supplier form' do
    render

    assert_select 'form[action=?][method=?]', supplier_path(supplier), 'post' do
      assert_select 'input[name=?]', 'supplier[name]'

      assert_select 'textarea[name=?]', 'supplier[contact_info]'
    end
  end
end
