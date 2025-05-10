# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'suppliers/show', type: :view do
  before(:each) do
    assign(:supplier, create(:supplier,
                             name: 'Name',
                             contact_info: 'MyText',
                             email: 'test@example.com'))
    assign(:supplier, create(:supplier))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to have_selector('p', text: 'Contact: Some contact info')
  end
end
