# frozen_string_literal: true

class Agent < ApplicationRecord
  belongs_to :company
  has_many :orders, dependent: :restrict_with_error
  has_one_attached :passport
  has_one_attached :workpermit

  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name phone email commission created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[company orders passport_attachment passport_blob workpermit_attachment workpermit_blob]
  end
end
