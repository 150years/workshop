# frozen_string_literal: true

# == Schema Information
#
# Table name: entries
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
#  index_entries_on_accountable_type_and_accountable_id  (accountable_type,accountable_id)
#  index_entries_on_date                                 (date)
#  index_entries_on_order_id                             (order_id)
#  index_entries_on_order_version_id                     (order_version_id)
#  index_entries_on_project_id                           (project_id)
#
class Journal < ApplicationRecord
  self.table_name = 'entries' # Это должно быть 'entries' вместо 'keepr_journals'

  belongs_to :order, optional: true

  has_many :postings, class_name: 'Posting', foreign_key: 'keepr_journal_id', inverse_of: :journal, dependent: :destroy
  accepts_nested_attributes_for :postings
end
