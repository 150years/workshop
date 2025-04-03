# frozen_string_literal: true

class OrderVersionsController < ApplicationController
  before_action :set_order
  before_action :set_order_version, except: %i[new create]

  def show; end

  # GET /order_versions/new
  def new
    @order_version = if params[:copy_from].blank?
                       OrderVersion.new
                     else
                       OrderVersion.find(params[:copy_from]).dup
                     end
  end

  # GET /order_versions/1/edit
  def edit; end

  # POST /order_versions
  def create
    @order_version = OrderVersion.new(order_version_params)
    @order_version.order = @order
    @order_version.company = @order.company

    if @order_version.save
      redirect_to @order, notice: 'Order version was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /order_versions/1
  def update
    if @order_version.update(order_version_params)
      redirect_to @order, notice: 'Order version was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /order_versions/1
  def destroy
    @order_version.destroy!
    redirect_to @order, notice: 'Order version was successfully destroyed.', status: :see_other
  end

  def mark_as_final
    @order_version.update(final_version: true)
    redirect_to order_path(@order), notice: 'Order version was successfully marked as final.'
  end

  private

  def set_order
    @order = current_company.orders.find(params[:order_id] || params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_order_version
    @order_version = @order.order_versions.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_version_params
    params.expect(order_version: %i[agent_comm profit version_note final_version])
  end
end
