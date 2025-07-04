# frozen_string_literal: true

class InstallationReportsController < ApplicationController
  before_action :set_order

  def show
    @installation_report = @order.installation_report
    return if @installation_report

    redirect_to order_path(@order), alert: 'Installation report not found.'
  end

  def create
    if @order.installation_report
      redirect_to order_installation_report_path(@order)
    else
      final_version = @order.order_versions.find_by(final_version: true)
      if final_version
        report = @order.create_installation_report!
        final_version.products.each do |product|
          report.installation_report_items.create!(product: product)
        end
        redirect_to order_installation_report_path(@order)
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
