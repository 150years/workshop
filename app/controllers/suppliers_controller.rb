# frozen_string_literal: true

class SuppliersController < ApplicationController
  before_action :set_supplier, only: %i[edit update destroy]

  # GET /suppliers
  def index
    @search = Supplier.ransack(params[:q])
    @pagy, @suppliers = pagy(@search.result.order(created_at: :desc))
  end

  def show
    @supplier = Supplier.find(params[:id])
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit; end

  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      redirect_to suppliers_path, notice: 'Supplier was successfully created.'
    else
      @search = Supplier.ransack(params[:q])
      @pagy, @suppliers = pagy(@search.result(distinct: true))
      render :index, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /suppliers/1
  def update
    if @supplier.update(supplier_params)
      redirect_to @supplier, notice: 'Supplier was successfully updated.', status: :see_other
    else
      render :index, status: :unprocessable_entity
    end
  end

  # DELETE /suppliers/1
  def destroy
    @supplier = Supplier.find(params[:id])
    @supplier.destroy
    redirect_to suppliers_path, notice: 'Supplier was successfully deleted.'
  end

  private

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  def supplier_params
    params.expect(supplier: %i[code name contact_info email])
  end
end
