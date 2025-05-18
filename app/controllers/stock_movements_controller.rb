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

  def create
    @stock_movement = StockMovement.new(stock_movement_params)
    @stock_movement.user = current_user

    if @stock_movement.save
      redirect_to stock_movements_path, notice: 'Movement recorded.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def summary
    @components = Component.with_quantities.order(:name)
  end

  private

  def set_stock_movement
    @stock_movement = StockMovement.find(params[:id])
  end

  def stock_movement_params
    params.require(:stock_movement).permit(:component_id, :order_id, :quantity, :movement_type, :comment)
  end
end
