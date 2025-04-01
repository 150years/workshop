# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'materials/show', type: :view do
  before(:each) do
    assign(:material, Material.create!(
                        name: 'Name',
                        price: 2.5,
                        supplier: nil,
                        code: 'Code'
                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Code/)
  end
end
