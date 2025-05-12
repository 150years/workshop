# frozen_string_literal: true

module TransactionsHelper
  def format_money(value)
    Money.from_amount(value).format
  end
end
