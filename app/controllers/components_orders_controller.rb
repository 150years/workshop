# frozen_string_literal: true

class ComponentsOrdersController < ApplicationController
  before_action :set_order
  before_action :set_final_version

  def index
    product_components = @version.products.includes(product_components: :component).flat_map(&:product_components)
    @aluminium_components = grouped_components(product_components, category: 'aluminum')
  end

  def print
    @supplier = Supplier.find(params[:supplier_id])

    product_components = @version.products.includes(product_components: :component).flat_map(&:product_components)

    @components = product_components
                  .select { |pc| pc.component.category == 'aluminum' && pc.component.supplier_id == @supplier.id }
                  .group_by(&:component)
                  .transform_values { |pcs| pcs.sum { |pc| pc.quantity.to_f * (pc.product.quantity || 1).to_f } }
  end

  private

  def set_order
    @order = current_company.orders.find(params.expect(:order_id))
  end

  def set_final_version
    @version = @order.order_versions.find_by(final_version: true) || @order.order_versions.last
  end

  def grouped_components(product_components, category:)
    product_components
      .select { |pc| pc.component.category == category }
      .group_by { |pc| pc.component.supplier }
      .transform_values do |components|
        components.group_by(&:component).transform_values do |pcs|
          pcs.sum { |pc| pc.quantity.to_f * (pc.product.quantity || 1).to_f }
        end
      end
  end
end
