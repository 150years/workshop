# frozen_string_literal: true

class OrderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/invoice
  delegate :invoice, to: :OrderMailer

  def invoice
    order_version = FactoryBot.create(:order_version)

    OrderMailer.invoice(order_version)
  end
end
