# frozen_string_literal: true

class ComponentsController < ApplicationController
  before_action :set_component, only: %i[show edit update destroy]

  # GET /components
  def index
    @components = current_company.components.all
  end

  # GET /components/1
  def show; end

  # GET /components/new
  def new
    @component = Component.new
  end

  # GET /components/1/edit
  def edit; end

  # POST /components
  def create
    @component = Component.new(component_params)
    @component.company = current_company

    if @component.save
      redirect_to @component, notice: 'Component was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /components/1
  def update
    if @component.update(component_params)
      redirect_to @component, notice: 'Component was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /components/1
  def destroy
    @component.destroy!
    redirect_to components_path, notice: 'Component was successfully destroyed.', status: :see_other
  end

  private

  def set_component
    @component = current_company.components.find(params.expect(:id))
  end

  def component_params
    params.expect(component: {}).permit(:code, :color, :unit, :min_quantity, :price)
  end
end
