# frozen_string_literal: true

class BalancesController < ApplicationController
  def index
    set_filters
    scope = filtered_scope
    @pagy, @transactions = pagy(scope, items: 10)
    calculate_totals(scope)
  end

  private

  def set_filters
    @from = params[:from].presence || 30.days.ago.to_date
    @to = params[:to].presence || Time.zone.today
  end

  def filtered_scope
    Transaction
      .where(date: @from..@to)
      .includes(:order, :client, :agent)
      .order(date: :asc)
  end

  def calculate_totals(scope)
    @income = scope.where('amount > 0').sum(:amount)
    @expense = scope.where('amount < 0').sum(:amount)
    @balance = @income + @expense
  end
end
