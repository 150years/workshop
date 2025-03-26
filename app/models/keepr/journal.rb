# frozen_string_literal: true

# app/models/keepr/journal.rb
# == Schema Information
#
# Table name: keepr_journals
#
#  id               :integer          not null, primary key
#  accountable_type :string
#  date             :date             not null
#  note             :text
#  number           :string
#  permanent        :boolean          default(FALSE), not null
#  subject          :string
#  created_at       :datetime
#  updated_at       :datetime
#  accountable_id   :integer
#  order_id         :integer          default(0), not null
#  order_version_id :integer
#  project_id       :integer
#
# Indexes
#
#  index_keepr_journals_on_accountable_type_and_accountable_id  (accountable_type,accountable_id)
#  index_keepr_journals_on_date                                 (date)
#  index_keepr_journals_on_order_id                             (order_id)
#  index_keepr_journals_on_order_version_id                     (order_version_id)
#  index_keepr_journals_on_project_id                           (project_id)
#
module Keepr
  class Journal < ApplicationRecord
    self.table_name = 'keepr_journals'

    belongs_to :order, optional: true
    belongs_to :order_version, optional: true

    has_many :keepr_postings, class_name: 'Keepr::Posting', foreign_key: 'keepr_journal_id', dependent: :destroy

    accepts_nested_attributes_for :keepr_postings

    validates :date, :subject, presence: true
    validate :balanced_journal

    private

    def balanced_journal
      debit = keepr_postings.select(&:debit?).sum(&:amount)
      credit = keepr_postings.select(&:credit?).sum(&:amount)
      errors.add(:base, 'Journal must be balanced') unless debit == credit
    end
  end
end
