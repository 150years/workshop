require 'rails_helper'

RSpec.describe DefectListItem, type: :model do
  it { should belong_to(:defect_list) }
  it { should belong_to(:product) }
  it { should have_many_attached(:photos) }

  it 'has valid statuses' do
    expect(DefectListItem.statuses.keys).to include('other', 'scratches', 'size_issue', 'sealant_color', 'sealant_quality', 'sealant_size', 'gaps', 'lock_and_handle')
  end
end
