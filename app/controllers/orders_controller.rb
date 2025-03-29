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

    calculate_totals
    calculate_progress
    set_progress_color
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
    @order.files.attach(params[:order][:files]) if params[:order][:files].present?
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

  def remove_file
    order = current_company.orders.find(params[:id])
    file = order.files.find(params[:file_id])
    file.purge
    redirect_to order_path(order), notice: 'File was successfully deleted.'
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
    params.expect(order: %i[client_id agent_id name status files: []])
  end

  def set_order_versions
    @order_versions = @order.order_versions.order(created_at: :desc)
  end

  def calculate_totals
    @total_amount = @final_version&.total_amount_cents.to_f / 100.0
    @paid_amount = @entries.sum { |e| e.postings.debit.sum(:amount) }
    @balance_due = @total_amount - @paid_amount
  end

  def calculate_progress
    @progress = begin
      if @total_amount.positive?
        [(@paid_amount / @total_amount * 100).round, 100].min
      else
        0
      end
    rescue StandardError
      0
    end
  end

  def set_progress_color
    @progress_color =
      if @progress < 30
        'bg-red-500'
      elsif @progress < 80
        'bg-yellow-400'
      else
        'bg-green-500'
      end
  end
end
