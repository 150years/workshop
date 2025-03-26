# frozen_string_literal: true

class ComponentsController < ApplicationController
  before_action :set_component, only: %i[show edit update destroy]

  # GET /components
  def index
    components = current_company.components.with_image_variants.order(id: :desc)

    @search = components.ransack(params[:q])
    @pagy, @components = pagy(@search.result(distinct: true))
  end

  # GET /components/1
  def show; end

  # GET /components/new
  def new
    if params[:template_id].blank?
      @component = Component.new(category: nil)
    else
      @original_component = current_company.components.find(params[:template_id])

      @component = @original_component.dup
      @component.name = "#{@component.name} (Copy)"
      @component.image.attach(@original_component.image.blob)
    end
  end

  # GET /components/1/edit
  def edit; end

  # POST /components
  def create
    @component = Component.new(component_params)
    @component.company = current_company

    attach_template_image

    if @component.save
      redirect_to @component, notice: 'Component was successfully created.'
    else
      @original_component = current_company.components.find(params[:template_id])
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /components/1
  def update
    # If image not modified in the form, remove it from the params
    component_params.delete(:image) if component_params[:image].blank?

    if @component.update(component_params)
      redirect_to @component, notice: 'Component was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /components/1
  def destroy
    if @component.destroy
      redirect_to components_path, notice: 'Component was successfully destroyed.', status: :see_other
    else
      flash[:alert] = @component.errors.first.message
      redirect_to @component, status: :see_other
    end
  end

  private

  def set_component
    @component = current_company.components.find(params.expect(:id))
  end

  def attach_template_image
    return unless component_params[:image].blank? && params[:template_id].present? && params[:image_blob_id].present?

    @component.image.attach(ActiveStorage::Blob.find_signed(params[:image_blob_id]))
  end

  def component_params
    params.expect(component: {}).permit(:code, :category, :name, :note, :color, :unit, :length, :width, :height,
                                        :thickness, :weight, :min_quantity, :price, :image)
  end
end
