class Posting < ApplicationRecord
  self.table_name = 'keepr_postings'

  belongs_to :journal, class_name: 'Journal', foreign_key: 'keepr_journal_id'
  belongs_to :account, class_name: 'Account', foreign_key: 'keepr_account_id'

  enum :side, { debit: 'debit', credit: 'credit' }

  validates :amount, presence: true, numericality: { greater_than: 0 }

  delegate :name, to: :account, prefix: true
end
