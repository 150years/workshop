# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'suppliers/new', type: :view do
  before(:each) do
    assign(:supplier, Supplier.new(
                        name: 'MyString',
                        contact_info: 'MyText'
                      ))
  end

  it 'renders new supplier form' do
    render

    assert_select 'form[action=?][method=?]', suppliers_path, 'post' do
      assert_select 'input[name=?]', 'supplier[name]'

      assert_select 'textarea[name=?]', 'supplier[contact_info]'
    end
  end
end
