# frozen_string_literal: true

# spec/support/view_helpers.rb
RSpec.configure do |config|
  config.before(:each, type: :view) do
    assign(:pagy, Pagy.new(count: 1, page: 1)) unless defined?(@pagy)
  end
end
