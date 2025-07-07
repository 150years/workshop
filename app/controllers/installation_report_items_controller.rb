# frozen_string_literal: true

class InstallationReportItemsController < ApplicationController
  before_action :set_item

  def update # rubocop:disable Metrics/AbcSize
    index = params[:index]

    # Сначала прикрепляем фото (если есть)
    params[:installation_report_item][:photos]&.each do |photo|
      @item.photos.attach(photo)
    end

    # Обновляем другие атрибуты
    success = @item.update(item_params)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@item, partial: 'installation_reports/item',
                                                         locals: { item: @item, index: index })
      end
      if success
        format.html { redirect_to order_installation_report_path(@item.installation_report.order), notice: 'Updated' }
      else
        format.html do
          redirect_to order_installation_report_path(@item.installation_report.order), notice: 'Update failed'
        end
      end
    end
  end

  def purge_photo
    # @item = InstallationReportItem.find(params[:id])
    blob = ActiveStorage::Blob.find_signed(params[:blob_id])
    attachment = @item.photos.attachments.find_by(blob_id: blob.id)
    attachment&.purge
    index = params[:index]

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@item, partial: 'installation_reports/item',
                                                         locals: { item: @item, index: index })
      end
      format.html do
        redirect_to order_installation_report_path(@item.installation_report.order), notice: 'Photo deleted.'
      end
    end
  end

  private

  def set_item
    @item = InstallationReportItem.find(params[:id])
  end

  def item_params
    params.expect(installation_report_item: %i[status comment comment_thai])
  end
end
