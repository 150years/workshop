# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :integer          default("quotation"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  agent_id   :integer          not null
#  client_id  :integer          not null
#  company_id :integer          not null
#
# Indexes
#
#  index_orders_on_agent_id    (agent_id)
#  index_orders_on_client_id   (client_id)
#  index_orders_on_company_id  (company_id)
#
# Foreign Keys
#
#  agent_id    (agent_id => agents.id)
#  client_id   (client_id => clients.id)
#  company_id  (company_id => companies.id)
#
class Order < ApplicationRecord
  belongs_to :company
  belongs_to :client
  belongs_to :agent
  has_many :order_versions, dependent: :destroy

  enum :status,
       {
         quotation: 0,
         measurement: 1,
         design: 2,
         payment: 3,
         production: 4,
         installation: 5,
         completed: 6,
         canceled: 7
       }
end
