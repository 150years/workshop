# frozen_string_literal: true

class BalancesController < ApplicationController
  def index
    set_date_range
    @mode = params[:mode].presence_in(%w[full acc]) || 'full'

    base_scope = Transaction
                 .where(date: @from..@to)
                 .includes(:order, :client, :agent)
                 .order(date: :desc, created_at: :desc)

    base_scope =
      case @mode
      when 'full'
        base_scope.where(only_for_accounting: [false, nil])
      when 'acc'
        base_scope.where(hidden: [false, nil])
      else
        base_scope
      end

    base_scope = apply_filters(base_scope)

    @pagy, @transactions = pagy(base_scope, items: 10)
    calculate_totals(base_scope)
  end

  def print
    set_date_range
    @mode = params[:mode].presence_in(%w[full acc]) || 'full'

    scope = Transaction
            .where(date: @from..@to)
            .includes(:order, :client, :agent)
            .order(date: :asc, created_at: :desc)

    scope =
      case @mode
      when 'full'
        scope.where(only_for_accounting: [false, nil])
      when 'acc'
        scope.where(hidden: [false, nil])
      else
        scope
      end

    @transactions = apply_filters(scope)
    calculate_totals(@transactions)

    render layout: 'print'
  end

  private

  def set_date_range
    @from = params[:from].presence || 30.days.ago.to_date
    @to = params[:to].presence || Time.zone.today
  end

  def apply_filters(scope)
    scope = scope.where(order_id: params[:order_id]) if params[:order_id].present?
    scope = scope.where(type_id: params[:type_id]) if params[:type_id].present?
    scope
  end

  def calculate_totals(scope)
    filtered_scope = apply_filters(scope)
    @total_credit = filtered_scope.where('amount > 0').sum(:amount)
    @total_debit = filtered_scope.where('amount < 0').sum(:amount)
    @income = @total_credit
    @expense = @total_debit
    @balance = @income + @expense
  end
end
