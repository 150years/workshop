# frozen_string_literal: true

class DefectListsController < ApplicationController
  before_action :set_order

  def show
    @defect_list = @order.defect_list
    return if @defect_list

    redirect_to order_path(@order), alert: 'Defect list not found.'
  end

  def create
    if @order.defect_list
      redirect_to order_defect_list_path(@order)
    else
      final_version = @order.order_versions.find_by(final_version: true)
      if final_version
        @order.create_defect_list!
        redirect_to order_defect_list_path(@order)
      else
        redirect_to order_path(@order), alert: 'Please select final version of order first.'
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end
