# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'products/show', type: :view do
  before(:each) do
    assign(:product, Product.create!(
                       name: 'Name',
                       width: 2,
                       height: 3,
                       comment: 'Comment'
                     ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Comment/)
  end
end
