# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'suppliers/show', type: :view do
  before(:each) do
    assign(:supplier, Supplier.create!(
                        name: 'Name',
                        contact_info: 'MyText'
                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
