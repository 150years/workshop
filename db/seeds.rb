# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

seed_file = Rails.root.join('db', 'seeds', "#{Rails.env}.rb")

if File.exist?(seed_file)
  puts "Seeding #{Rails.env} environment data..." # rubocop:disable Rails/Output
  require seed_file
else
  puts "No seed file for #{Rails.env} environment." # rubocop:disable Rails/Output
end
