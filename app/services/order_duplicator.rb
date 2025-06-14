# frozen_string_literal: true

# app/services/order_duplicator.rb
class OrderDuplicator
  def self.duplicate_order(order)
    new_order = order.dup
    new_order.name = "#{order.name} (copy)"
    new_order.status = :quotation
    new_order.skip_initial_version = true
    new_order.save!

    source_version = order.order_versions.find_by(final_version: true) ||
                     order.order_versions.order(created_at: :desc).first
    duplicate_version_to_order(source_version, new_order) if source_version

    new_order
  end

  def self.duplicate_version(order_version)
    duplicate_version_to_order(order_version, order_version.order)
  end

  def self.duplicate_version_to_order(source_version, target_order)
    new_version = source_version.dup
    new_version.order = target_order
    new_version.final_version = false
    new_version.quotation_number = nil
    new_version.save!

    copy_products(source_version, new_version)

    new_version.update_total_amount
    new_version
  end

  def self.copy_products(source_version, new_version)
    source_version.products.each do |product|
      new_product = product.dup
      new_product.order_version = new_version
      new_product.save!

      product.product_components.each do |pc|
        new_product.product_components.create!(
          component_id: pc.component_id,
          quantity: pc.quantity,
          quantity_real: pc.quantity_real,
          quantity_manual: pc.quantity_manual,
          formula: pc.formula,
          ratio: pc.ratio,
          waste: pc.waste
        )
      end

      new_product.image.attach(product.image.blob) if product.image.attached?
    end
  end
end
