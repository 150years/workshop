# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    @search = Transaction.ransack(params[:q])
    @transactions = @search.result.includes(:order, :client, :agent).order(date: :desc)
    @pagy, @transactions = pagy(@transactions)
  end

  def new
    @transaction = Transaction.new(date: Time.zone.today)
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      redirect_to transactions_path, notice: 'Transaction created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.expect(
      transaction: %i[date description amount type_id order_id agent_id client_id]
    )
  end
end
