# frozen_string_literal: true

module UnitConverter
  def self.mm_to_m(value)
    return nil if value.nil?

    (value.to_f / 1000).round(4)
  end

  def self.mm2_to_m2(value)
    return nil if value.nil?

    (value.to_f / 1_000_000).round(4)
  end

  def self.mm2_to_ft2(value)
    return nil if value.nil?

    (mm2_to_m2(value) * 10.7639).round(4)
  end

  def self.g_to_kg(value)
    return nil if value.nil?

    (value.to_f / 1000).round(4)
  end
end
