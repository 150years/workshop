# frozen_string_literal: true

class ComponentOrderMailer < ApplicationMailer
  def send_component_order(order, version, supplier, pdf)
    @order = order
    @version = version

    attachments["#{version.full_quotation_number}_#{order.name.parameterize}.pdf"] = pdf

    mail(
      # to: supplier.email, # или конкретный email
      to: 'bytheair@gmail.com', # или конкретный email
      subject: "Component Order - #{order.name} #{version.full_quotation_number}"
    )
  end
end
