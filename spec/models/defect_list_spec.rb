# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DefectList, type: :model do
  it { should belong_to(:order) }
  it { should have_many(:defect_list_items).dependent(:destroy) }
end
