# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[edit update destroy]

  def index
    @search = Transaction.ransack(params[:q])
    @transactions = @search.result.includes(:order, :client, :agent).order(date: :desc)
    @pagy, @transactions = pagy(@transactions)
  end

  def new
    @transaction = Transaction.new(date: Time.zone.today)
  end

  def edit
    # @transaction = Transaction.find(params[:id])
    redirect_to balances_path, alert: 'Editing not allowed after 7 days.' unless @transaction.editable?
  end

  def create
    @transaction = current_company.transactions.new(transaction_params)

    if @transaction.save
      redirect_to balances_path, notice: 'Transaction created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # @transaction = Transaction.find(params[:id])
    redirect_to balances_path, alert: 'Editing not allowed after 7 days.' and return unless @transaction.editable?

    if @transaction.update(transaction_params)
      redirect_to balances_path, notice: 'Transaction updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # @transaction = Transaction.find(params[:id])
    redirect_to balances_path, alert: 'Editing not allowed after 7 days.' and return unless @transaction.editable?

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

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

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
