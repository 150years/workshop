# frozen_string_literal: true

class StockMovementsController < ApplicationController
  before_action :set_stock_movement, only: %i[]

  def index
    @search = StockMovement.ransack(params[:q])
    @pagy, @stock_movements = pagy(
      @search.result.includes(:component, :order).order(created_at: :desc)
    )
  end

  def new
    @stock_movement = StockMovement.new
  end

  def edit
    @stock_movement = StockMovement.find(params[:id])
  end

  def create
    @stock_movement = StockMovement.new(stock_movement_params)
    @stock_movement.user = current_user

    if @stock_movement.save
      redirect_to stock_movements_path, notice: 'Movement recorded.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @stock_movement = StockMovement.find(params[:id])
    if @stock_movement.update(stock_movement_params)
      redirect_to stock_movements_path, notice: 'Movement updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock_movement = StockMovement.find(params[:id])
    @stock_movement.destroy

    permitted_q = params[:q]&.permit(:component_id_eq, :order_id_eq)
    redirect_to stock_movements_path(q: permitted_q), notice: 'Movement deleted.'
  end

  def summary
    @order = Order.find_by(id: params[:order_id])
    @orders = Order.order(:name)
    @components = Component.with_quantities.order(:code)

    @component_quantities = @components.map do |component|
      stock_quantity =
        if @order.present?
          component.available_project_quantity(@order.id)
        else
          component.available_stock_quantity
        end

      in_projects_quantity = component.quantity_in_projects

      [component, stock_quantity, in_projects_quantity]
    end
  end

  private

  def set_stock_movement
    @stock_movement = StockMovement.find(params[:id])
  end

  def stock_movement_params
    params.expect(stock_movement: %i[component_id order_id quantity movement_type comment])
  end
end
