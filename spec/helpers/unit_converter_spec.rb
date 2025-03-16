# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitConverter, type: :helper do
  describe '#mm_to_m' do
    it 'converts millimeters to meters' do
      expect(UnitConverter.mm_to_m(1000)).to eq(1.0)
    end

    it 'returns nil when input is nil' do
      expect(UnitConverter.mm_to_m(nil)).to be_nil
    end

    it 'handles zero' do
      expect(UnitConverter.mm_to_m(0)).to eq(0.0)
    end
  end

  describe '.mm2_to_m2' do
    it 'converts square millimeters to square meters' do
      expect(UnitConverter.mm2_to_m2(1_000_000)).to eq(1.0)
    end

    it 'returns nil when input is nil' do
      expect(UnitConverter.mm2_to_m2(nil)).to be_nil
    end

    it 'handles zero' do
      expect(UnitConverter.mm2_to_m2(0)).to eq(0.0)
    end
  end

  describe '.mm2_to_ft2' do
    it 'converts square millimeters to square feet' do
      expect(UnitConverter.mm2_to_ft2(1_000_000)).to eq(10.7639)
    end

    it 'returns nil when input is nil' do
      expect(UnitConverter.mm2_to_ft2(nil)).to be_nil
    end

    it 'handles zero' do
      expect(UnitConverter.mm2_to_ft2(0)).to eq(0.0)
    end
  end
end
