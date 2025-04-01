# frozen_string_literal: true

class MaterialsController < ApplicationController
  include Pagy::Backend

  def index
    @search = Material.ransack(params[:q])
    materials = @search.result.order(:name)

    if params[:order_id].present?
      materials = materials
                  .joins(:material_uses)
                  .where(material_uses: { order_id: params[:order_id] })
                  .distinct
    end

    @pagy, @materials = pagy(materials)
  end

  def show; end

  def new
    @material = Material.new
  end

  def edit
    @material = Material.find(params[:id])
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      redirect_to materials_path, notice: 'Material was successfully created.'
    else
      render :new
    end
  end

  def update
    @material = Material.find(params[:id])
    if @material.update(material_params)
      redirect_to materials_path, notice: 'Material was successfully updated.'
    else
      render :index
    end
  end

  def destroy
    @material = Material.find(params[:id])
    @material.destroy
    redirect_to materials_path, notice: 'Material was successfully deleted.'
  end

  private

  def material_params
    params.expect(material: %i[name price code supplier_id image amount])
  end
end
