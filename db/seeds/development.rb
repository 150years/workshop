# frozen_string_literal: true

# rubocop:disable Rails/Output

# Clear ActiveStorage data
# Get all folders in storage directory, except for the .keep file and .sqlite3 databases and delete them including subfolders
Dir.glob('storage/*').each do |file|
  next if file.include?('.keep') || file.include?('sqlite3')

  FileUtils.rm_rf(file)
end
puts 'ActiveStorage data cleared'

# Create a company
# First check if there is a company
company = Company.create!(name: 'My Company')
puts 'Company created'

# Create a user
User.create!(name: 'Admin', email: 'admin@admin.com', password: 'password', company: company)
puts "Created user: admin@admin.com, password: 'password'"

# Create 5 other company users
FactoryBot.create_list(:user, 5, company: company, password: 'password')
puts '5 more company users created'

# Create 5 agents. One wuth passport and worpermit, two with passport, two with workpermit
FactoryBot.create_list(:agent, 1, :with_passport, :with_workpermit, company: company)
FactoryBot.create_list(:agent, 2, :with_passport, company: company)
FactoryBot.create_list(:agent, 2, :with_workpermit, company: company)
puts '5 agents created'

# Create components
components = FactoryBot.create_list(:component, 5, company: company)
puts '5 components created'

# Create 5 product templates using random components
product_templates = FactoryBot.create_list(:product, 5, company: company)

product_templates.each do |product_template|
  rand(1..5).times do
    FactoryBot.create(:product_component, product: product_template, component: components.sample)
  end
end
puts '5 product templates created'

# Create 5 orders
orders = FactoryBot.create_list(:order, 5, company: company, agent: company.agents.sample, client: company.clients.sample)

orders.each do |order|
  # For each order we need to create 0-5 order versions. One order version is created automatically when we create order
  rand(0..5).times do
    FactoryBot.create(:order_version, order: order, company: company)
  end
  # Select 0-1 random order versions for each order and mark it is final
  rand(0..1).times do
    order.order_versions.sample.update!(final_version: true)
  end
end
puts '5 orders created'

# For each order version add random number (1-10) of products
OrderVersion.find_each do |order_version|
  rand(1..10).times do
    FactoryBot.create(:product, order_version: order_version, company: company, from_template: true, template_id: product_templates.sample.id)
  end
end
puts 'Products added to order versions'

puts 'Database seeded. Please restart the application to see the changes.'

# rubocop:enable Rails/Output

# Accountig
Account.create!(name: 'Cash', account_type: :asset)
Account.create!(name: 'Accounts Receivable', account_type: :asset)
Account.create!(name: 'Sales - Windows', account_type: :income)
Account.create!(name: 'Sales - Doors', account_type: :income)
Account.create!(name: 'Agent Commissions', account_type: :expense)
Account.create!(name: 'Materials - Aluminum', account_type: :expense)
Account.create!(name: 'Accounts Payable', account_type: :liability)
