# frozen_string_literal: true

# == Schema Information
#
# Table name: keepr_accounts
#
#  id               :integer          not null, primary key
#  accountable_type :string
#  ancestry         :string
#  kind             :integer          not null
#  name             :string           not null
#  number           :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#  accountable_id   :integer
#  keepr_group_id   :integer
#  keepr_tax_id     :integer
#
# Indexes
#
#  index_keepr_accounts_on_accountable_type_and_accountable_id  (accountable_type,accountable_id)
#  index_keepr_accounts_on_ancestry                             (ancestry)
#  index_keepr_accounts_on_keepr_group_id                       (keepr_group_id)
#  index_keepr_accounts_on_keepr_tax_id                         (keepr_tax_id)
#  index_keepr_accounts_on_number                               (number)
#
class Account < ApplicationRecord
  self.table_name = 'keepr_accounts'

  has_many :postings, foreign_key: 'keepr_account_id', dependent: :destroy

  enum :kind, {
    asset: 0,
    liability: 1,
    equity: 2,
    revenue: 3,
    expense: 4
  }
end
