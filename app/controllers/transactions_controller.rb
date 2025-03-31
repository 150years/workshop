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
    @transaction = current_company.transactions.new(transaction_params)

    if @transaction.save
      redirect_to balances_path, notice: 'Transaction created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    redirect_to balances_path, notice: 'Transaction was successfully deleted.', status: :see_other
  end

  def destroy_attachment
    transaction = Transaction.find(params[:id])
    file = transaction.files.find(params[:file_id])
    file.purge_later

    redirect_back fallback_location: edit_transaction_path(transaction), notice: 'Файл удалён'
  end

  private

  def transaction_params
    params.expect(
      transaction: [
        :date,
        :description,
        :amount,
        :type_id,
        :order_id,
        :agent_id,
        :client_id,
        { files: [] }
      ]
    )
  end
end
