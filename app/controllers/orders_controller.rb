# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order,
                only: %i[
                  show
                  edit
                  update
                  destroy
                  send_quotation_email
                  quotation_preview
                ]
  before_action :set_clients_and_agents, except: %i[index show destroy]
  before_action :set_order_versions, only: %i[show]
  before_action :set_final_version, only: %i[quotation_preview]

  # GET /orders
  def index
    orders = current_company.orders.order(id: :desc)

    @search = orders.ransack(params[:q])
    @pagy, @orders = pagy(@search.result)
  end

  # GET /orders/1
  def show; end

  # GET /orders/new
  # def new
  #   @order = if params[:copy_from].blank?
  #              Order.new
  #            else
  #              current_company.orders.find(params[:copy_from]).dup
  #            end
  # end

  def new
    # if params[:copy_from].present?
    #   source_order = current_company.orders.find(params[:copy_from])
    #   @order = OrderDuplicator.duplicate_order(source_order)
    #   redirect_to edit_order_path(@order)
    # else
    @order = Order.new
    # end
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

  def duplicate
    source_order = current_company.orders.find(params[:id])
    @order = OrderDuplicator.duplicate_order(source_order)
    redirect_to edit_order_path(@order), notice: 'Order copied'
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

  def quotation_preview
    @labor_total = calculate_labor_total(@version)
    @withholding_tax = (@labor_total * 0.03).round(2)
    render layout: 'print'
  end

  def add_custom_code
    version = OrderVersion.find(params[:version_id])
    version.update(quotation_custom_code: params[:custom_code])
    redirect_to quotation_preview_order_path(version.order)
  end

  def send_quotation_email
    OrderMailer.with(order: @order).quotation_email.deliver_later

    redirect_to quotation_preview_order_path(@order), notice: "Quotation was sent to #{@order.client.email}"
  end

  private

  def set_order
    @order = current_company.orders.find(params.expect(:id))
  end

  def set_clients_and_agents
    @clients = current_company.clients
    @agents = current_company.agents
  end

  def order_params
    params.expect(order: %i[client_id agent_id name initial_profit status files: []])
  end

  def set_order_versions
    @order_versions = @order.order_versions.order(created_at: :desc)
  end

  def set_final_version
    @version = @order.order_versions.find_by(final_version: true) || @order.order_versions.last
  end

  def calculate_labor_total(version)
    total_cents = version.products.includes(product_components: :component).sum do |product|
      labor_component_price(product)
    end

    total_with_profit_cents = (total_cents * (1 + (version.profit.to_f / 100))).round
    Money.new(total_with_profit_cents, version.currency || 'THB')
  end

  def labor_component_price(product)
    product.product_components
           .select { |pc| pc.component.name.to_s.downcase.include?('labor') }
           .sum { |pc| product.quantity.to_f * pc.quantity.to_f * (pc.component.price_cents || 0) }
  end
end
