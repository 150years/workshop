# frozen_string_literal: true

class ProductComponentsController < ApplicationController
  before_action :set_product
  # before_action :set_product_component, except: %i[new create]
  before_action :set_product_component, only: %i[edit update destroy update_quantity]

  # GET /product_components/new
  def new
    @product_component = @product.product_components.new
  end

  # GET /product_components/1/edit
  def edit; end

  # POST /product_components
  def create
    @product_component = @product.product_components.new(product_component_params)

    if @product_component.save
      redirect_to @product, notice: 'Product component was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_components/1
  def update
    if @product_component.update(product_component_params)
      redirect_to @product, notice: 'Product component was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_quantity
    if @product_component.update(quantity_manual: params[:product_component][:quantity_manual])
      redirect_to order_path(@product_component.product.order_version.order), notice: 'Quantity updated'
    else
      flash[:alert] = @product_component.errors.full_messages.to_sentence
      redirect_to order_path(@product_component.product.order_version.order)
    end
  end

  # DELETE /product_components/1
  def destroy
    @product_component.destroy!
    redirect_to @product, notice: 'Product component was successfully destroyed.', status: :see_other
  end

  private

  def set_product
    @product = current_company.products.find(params.expect(:product_id))
  end

  def set_product_component
    @product_component = @product.product_components.find(params.expect(:id))
  end

  def product_component_params
    params.expect(product_component: %i[component_id formula])
  end
end
