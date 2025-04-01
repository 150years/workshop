# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'materials/index', type: :view do
  before(:each) do
    assign(:materials, [
             Material.create!(
               name: 'Name',
               price: 2.5,
               supplier: nil,
               code: 'Code'
             ),
             Material.create!(
               name: 'Name',
               price: 2.5,
               supplier: nil,
               code: 'Code'
             )
           ])
  end

  it 'renders a list of materials' do
    render
    # cell_selector = 'div>p'
    # assert_select cell_selector, text: Regexp.new('Name'), count: 2
    # assert_select cell_selector, text: Regexp.new(2.5.to_s), count: 2
    # assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    # assert_select cell_selector, text: Regexp.new('Code'), count: 2
  end
end
