# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :set_order_version, only: %i[new create]

  # GET /products
  def index
    products = current_company.products.with_image_variants.where(order_version_id: nil).order(id: :desc)

    @search = products.ransack(params[:q])
    @pagy, @products = pagy(@search.result(distinct: true))
  end

  # GET /products/1
  def show
    @product_components = @product.product_components.includes(component: :company).group_by do |pc|
      pc.component.category
    end
  end

  # GET /products/new
  def new
    @product = Product.new(order_version_id: @order_version&.id, from_template: params[:from_template])
  end

  # GET /products/1/edit
  def edit; end

  # POST /products
  def create
    @product = Product.new(product_params)
    @product.company = current_company
    @product.order_version_id = @order_version.id if @order_version

    if @product.save
      if @order_version
        render turbo_stream: turbo_stream.update(@order_version, partial: 'order_versions/order_version',
                                                                 locals: { order_version: @product.order_version })

      else
        redirect_to @product, notice: 'Product template was successfully created.'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product template was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy!
    if @product.order_version
      render turbo_stream: turbo_stream.update(@product.order_version,
                                               partial: 'order_versions/order_version',
                                               locals: { order_version: @product.order_version })
    else
      redirect_to products_path, notice: 'Product template was successfully destroyed.', status: :see_other
    end
  end

  private

  def set_product
    @product = current_company.products.find(params.expect(:id))
  end

  def set_order_version
    @order_version = (current_company.order_versions.find(params[:order_version_id]) if params[:order_version_id])
  end

  def product_params
    params.expect(product: %i[name width height comment image from_template template_id quantity])
  end
end
