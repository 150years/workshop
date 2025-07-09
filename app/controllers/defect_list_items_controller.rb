# frozen_string_literal: true

class DefectListItemsController < ApplicationController
  before_action :set_defect_list
  before_action :set_defect_list_item, only: %i[update destroy purge_photo edit_photo]

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

  def update # rubocop:disable Metrics/AbcSize
    if params[:defect_list_item][:photo_before].present?
      @item.photo_before.attach(params[:defect_list_item][:photo_before])
    end

    if params[:defect_list_item][:photo_after].present?
      @item.photo_after.attach(params[:defect_list_item][:photo_after])
    end

    @item.update(defect_list_item_params)

    @item.defect_list.touch # rubocop:disable Rails/SkipsModelValidations

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@item, partial: 'defect_lists/item',
                                                         locals: { item: @item })
      end
      format.html { redirect_to order_defect_list_path(@defect_list.order) }
    end
  end

  def edit_photo
    field = params[:field] # например, "photo_before" или "photo_after"
    file = params[:defect_list_item]&.[](field.to_s)

    if file.present? && %w[photo_before photo_after].include?(field)
      @item.send(field).attach(file)
      @item.defect_list.touch # rubocop:disable Rails/SkipsModelValidations

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@item,
                                                    partial: 'defect_lists/item',
                                                    locals: { item: @item })
        end
        format.html { head :ok }
      end
    else
      head :unprocessable_entity
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
    case params[:which]
    when 'before'
      @item.photo_before.purge if @item.photo_before.attached?
    when 'after'
      @item.photo_after.purge if @item.photo_after.attached?
    end

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
    @defect_list = Order.find(params[:order_id]).defect_list
  end

  def set_defect_list_item
    @item = @defect_list.defect_list_items.find(params[:id])
  end

  def defect_list_item_params
    params.fetch(:defect_list_item, {}).permit(:status, :comment, :comment_thai)
  end
end
