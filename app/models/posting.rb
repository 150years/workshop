# frozen_string_literal: true

# == Schema Information
#
# Table name: keepr_postings
#
#  id                   :integer          not null, primary key
#  accountable_type     :string
#  amount               :decimal(8, 2)    not null
#  side                 :string
#  created_at           :datetime
#  updated_at           :datetime
#  accountable_id       :integer
#  keepr_account_id     :integer          not null
#  keepr_cost_center_id :integer
#  keepr_journal_id     :integer          not null
#
# Indexes
#
#  index_keepr_postings_on_accountable_type_and_accountable_id  (accountable_type,accountable_id)
#  index_keepr_postings_on_keepr_account_id                     (keepr_account_id)
#  index_keepr_postings_on_keepr_cost_center_id                 (keepr_cost_center_id)
#  index_keepr_postings_on_keepr_journal_id                     (keepr_journal_id)
#
class Posting < ApplicationRecord
  self.table_name = 'keepr_postings'

  belongs_to :journal, class_name: 'Journal', foreign_key: 'keepr_journal_id', inverse_of: :account
  belongs_to :account, class_name: 'Account', foreign_key: 'keepr_account_id', inverse_of: :account

  enum :side, { debit: 'debit', credit: 'credit' }

  validates :amount, presence: true, numericality: { greater_than: 0 }

  delegate :name, to: :account, prefix: true
end
