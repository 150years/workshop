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
#  agent_id   :integer
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
  belongs_to :agent, optional: true
  has_many :order_versions, dependent: :destroy
  has_many_attached :files
  has_one :installation_report, dependent: :destroy
  has_one :defect_list, dependent: :destroy

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

  before_commit :create_order_version, on: %i[create]

  attr_accessor :initial_profit, :skip_initial_version

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name status created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[client agent]
  end

  def final_or_latest_version
    order_versions.order(final_version: :desc, created_at: :desc).first
  end

  def latest_version_total
    Money.new(final_or_latest_version&.reload&.total_amount_cents || 0, 'THB')
  end

  private

  def create_order_version
    return if skip_initial_version

    order_versions.create!(
      company: company,
      version_note: 'Initial version',
      profit: initial_profit.presence || 0
    )
  end
end
