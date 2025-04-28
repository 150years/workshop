# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  describe 'invoice' do
    let(:mail) { OrderMailer.invoice(order_version) }
    let(:order_version) { create(:order_version) }

    it 'renders the headers' do
      expect(mail.subject).to eq("Invoice for Order ##{order_version.order.id}")
      expect(mail.to).to eq([order_version.order.client.email])
      expect(mail.from).to eq(['noreply@aluworkshop.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Thank you for your order. Your order number is #{order_version.order.id}.")
    end
  end
end
