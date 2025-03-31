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

  def edit
    @transaction = Transaction.new(date: Time.zone.today)
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      redirect_to transactions_path, notice: 'Transaction created'
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    redirect_to balances_path, notice: 'Transaction was successfully deleted.', status: :see_other
  end

  private

  def transaction_params
    params.expect(
      transaction: %i[date description amount type_id order_id agent_id client_id]
    )
  end
end
