# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/component_order_mailer_mailer
class ComponentOrderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/component_order_mailer_mailer/send_comnponent_order
  delegate :send_comnponent_order, to: :ComponentOrderMailer
end
