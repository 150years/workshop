# frozen_string_literal: true

# app/models/concerns/price_calculations.rb
module PriceCalculations
  extend ActiveSupport::Concern

  def aluminum_price_cents
    product_components.joins(:component)
                      .where(components: { category: 'aluminum' })
                      .sum('components.price_cents * product_components.quantity')
                      .to_i
  end

  def glass_price_cents
    product_components.joins(:component)
                      .where(components: { category: 'glass' })
                      .sum('components.price_cents * product_components.quantity')
                      .to_i
  end

  def other_price_cents
    product_components.joins(:component)
                      .where(components: { category: 'other' })
                      .sum('components.price_cents * product_components.quantity')
                      .to_i
  end

  # For 1 product
  def profit_amount_cents
    (nett_price_cents * profit_percentage / 100.0).round
  end

  # For 1 product
  def nett_price_cents
    aluminum_price_cents + glass_price_cents + other_price_cents
  end

  # For 1 product
  def price_with_profit_cents
    nett_price_cents + profit_amount_cents
  end

  # For product x product.quantity
  def total_nett_price_cents
    (nett_price_cents * (quantity || 1)).round
  end

  # For product x product.quantity
  def total_profit_amount_cents
    (profit_amount_cents * (quantity || 1)).round
  end

  # For product x product.quantity
  def total_price_with_profit_cents
    (price_with_profit_cents * (quantity || 1)).round
  end
end
