# frozen_string_literal: true

class DefectListItemsController < ApplicationController
  before_action :set_defect_list
  before_action :set_defect_list_item, only: %i[update destroy purge_photo]

  def create
    @item = @defect_list.defect_list_items.create!(product_id: params[:product_id], status: :other)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append('defect_list_items', partial: 'defect_lists/item',
                                                                      locals: { item: @item })
      end
      format.html { redirect_to order_defect_list_path(@defect_list.order) }
    end
  end

  def update
    if @item.update(defect_list_item_params) && params[:defect_list_item][:photos]
      params[:defect_list_item][:photos].each do |photo|
        @item.photos.attach(photo)
      end
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@item, partial: 'defect_lists/item',
                                                         locals: { item: @item })
      end
      format.html { redirect_to order_defect_list_path(@defect_list.order) }
    end
  end

  def destroy
    @item.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@item)
      end
      format.html { redirect_to order_defect_list_path(@defect_list.order) }
    end
  end

  def purge_photo
    photo = @item.photos.find(params[:photo_id])
    photo.purge_later

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@item, partial: 'defect_lists/item',
                                                         locals: { item: @item })
      end
      format.html { redirect_to order_defect_list_path(@defect_list.order) }
    end
  end

  private

  def set_defect_list
    # @defect_list = DefectList.find(params[:defect_list_id])
    @defect_list = Order.find(params[:order_id]).defect_list
  end

  def set_defect_list_item
    @item = @defect_list.defect_list_items.find(params[:id])
  end

  def defect_list_item_params
    params.require(:defect_list_item).permit(:status, :comment, :comment_thai)
  end
end
