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
  def show; end

  # GET /orders/new
  def new
    @order = if params[:copy_from].blank?
               Order.new
             else
               current_company.orders.find(params[:copy_from]).dup
             end
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

  # def quotation_pdf
  #   @order = current_company.orders.find(params[:id])
  #   @version = @order.order_versions.order(created_at: :desc).first
  #   pdf = Orders::QuotationPdfGenerator.new(@order, @version).render

  #   send_data pdf,
  #             filename: @version.pdf_filename(@order),
  #             type: 'application/pdf',
  #             disposition: 'inline'
  # end

  # def components_order
  #   @order = current_company.orders.find(params[:id])
  #   @version = @order.order_versions.order(created_at: :desc).first
  #   @grouped_components = @version.grouped_components_by_category_and_supplier(@order, @version)
  #   fetch_product_components
  #   @minimal_layout = params[:bare].present?
  # end

  private

  def set_order
    @order = current_company.orders.find(params.expect(:id))
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
end
