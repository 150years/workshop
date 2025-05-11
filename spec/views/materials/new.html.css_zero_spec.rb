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
end
