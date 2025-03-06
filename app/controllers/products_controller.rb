# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :set_order_version, only: %i[create]

  # GET /products
  def index
    @products = current_company.products.includes(image_attachment: [blob: { variant_records: :blob }])
                               .where(order_version_id: nil)
  end

  # GET /products/1
  def show; end

  # GET /products/new
  def new
    @product = Product.new
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
                                                                 locals: { order_version: @order_version })

      else
        redirect_to @product, notice: 'Product was successfully created.'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    # If image not modified in the form, remove it from the params
    product_params.delete(:image) if product_params[:image].blank?

    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy!
    redirect_to products_path, notice: 'Product was successfully destroyed.', status: :see_other
  end

  private

  def set_product
    @product = current_company.products.includes(product_components: [:component]).find(params.expect(:id))
  end

  def set_order_version
    @order_version = (current_company.order_versions.find(params[:order_version_id]) if params[:order_version_id])
  end

  def product_params
    params.expect(product: %i[name width height comment image])
  end
end
