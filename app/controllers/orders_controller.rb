# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]
  before_action :set_clients_and_agents, except: %i[index show destroy]
  before_action :set_order_versions, only: %i[show]

  # GET /orders
  def index
    orders = current_company.orders.order(id: :desc)

    @search = orders.ransack(params[:q])
    @pagy, @orders = pagy(@search.result)
  end

  # GET /orders/1
  def show
    @entries = Journal.where(order_id: @order.id)

    @final_version = @order.order_versions.find_by(final_version: true)
    @total_amount = @final_version&.total_amount_cents.to_f / 100.0
    @paid_amount = @entries.sum { |e| e.postings.debit.sum(:amount) }
    # 🛡️ Безопасный расчёт с ограничением
    if @total_amount.positive?
      raw_pct = (@paid_amount / @total_amount * 100).round
      @progress = [raw_pct, 100].min
    else
      @progress = 0
    end
    @balance_due = @total_amount - @paid_amount
    @progress = begin
      [(@paid_amount / @total_amount * 100).round, 100].min
    rescue StandardError
      0
    end
    @progress_color =
      if @progress < 30
        'bg-red-500'
      elsif @progress < 80
        'bg-yellow-400'
      else
        'bg-green-500'
      end
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.company = current_company

    if @order.save
      redirect_to @order, notice: 'Order was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy!
    redirect_to orders_path, notice: 'Order was successfully destroyed.', status: :see_other
  end

  def receive_advance_payment
    order = Order.find(params[:id])
    version = order.order_versions.find_by(final_version: true)

    if version.nil?
      redirect_to order_path(order), alert: 'No confirmed version found.'
      return
    end

    version.total_amount_cents
    amount = (version.total_amount_cents * 0.5).round / 100.0 # ✅

    Journal.create!(
      subject: "Advance Payment for Order ##{order.id}",
      date: Time.zone.today,
      order_id: order.id,
      order_version_id: version.id,
      postings_attributes: [
        { account: Account.find_by(name: 'Cash'), amount: amount, side: 'debit' },
        { account: Account.find_by(name: 'Accounts Receivable'), amount: amount, side: 'credit' }
      ]
    )

    redirect_to order_path(order), notice: 'Advance payment recorded.'
  end

  def new_payment
    @order = current_company.orders.find(params[:id])
    @version = @order.order_versions.find_by(final_version: true)
    @total_amount = @version.total_amount_cents / 100.0
  end

  def create_manual_payment
    order = current_company.orders.find(params[:id])
    version = order.order_versions.find_by(final_version: true)
    total = version.total_amount_cents / 100.0

    percent = params[:percent].to_f
    amount = (total * (percent / 100.0)).round(2)

    # ✅ добавим проверку
    cash_account = Account.find_by(name: 'Cash')
    paid = Journal.where(order_id: order.id).sum do |e|
      e.postings.where(account: cash_account, side: 'debit').sum(:amount)
    end

    if paid + amount > total
      redirect_to order_path(order), alert: 'Сумма оплаты превышает сумму заказа.'
      return
    end

    Journal.create!(
      subject: "Платёж #{percent}% за заказ ##{order.id}",
      date: Time.zone.today,
      order_id: order.id,
      order_version_id: version.id,
      postings_attributes: [
        { account: cash_account, amount: amount, side: 'debit' },
        { account: Account.find_by(name: 'Accounts Receivable'), amount: amount, side: 'credit' }
      ]
    )

    redirect_to order_path(order), notice: "Платёж на #{percent}% успешно записан."
  end

  def receive_next_payment
    order = Order.find(params[:id])
    version = order.order_versions.find_by(final_version: true)
    total = version.total_amount_cents / 100.0

    cash_account = Account.find_by(name: 'Cash')
    receivable_account = Account.find_by(name: 'Accounts Receivable')

    paid = Journal.where(order_id: order.id).sum do |e|
      e.postings.where(account: cash_account, side: 'debit').sum(:amount)
    end

    next_percent =
      if paid < total * 0.5
        0.5
      elsif paid < total * 0.9
        0.4
      elsif paid < total
        0.1
      else
        0
      end

    if next_percent.zero?
      redirect_to order_path(order), alert: 'Все платежи уже получены.'
      return
    end

    amount = (total * next_percent).round(2)

    Journal.create!(
      subject: "Следующий платёж #{(next_percent * 100).to_i}% за заказ ##{order.id}",
      date: Time.zone.today,
      order_id: order.id,
      order_version_id: version.id,
      postings_attributes: [
        { account: cash_account, amount: amount, side: 'debit' },
        { account: receivable_account, amount: amount, side: 'credit' }
      ]
    )

    redirect_to order_path(order), notice: "Платёж на #{(next_percent * 100).to_i}% успешно записан."
  end

  private

  def set_order
    @order = current_company.orders.find(params[:id])
  end

  def set_clients_and_agents
    @clients = current_company.clients
    @agents = current_company.agents
  end

  def order_params
    params.expect(order: %i[client_id agent_id name status])
  end

  def set_order_versions
    @order_versions = @order.order_versions.order(created_at: :desc)
  end
end
