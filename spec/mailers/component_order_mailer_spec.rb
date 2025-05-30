# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComponentOrderMailer, type: :mailer do
  describe 'send_comnponent_order' do
    let(:mail) { ComponentOrderMailer.send_comnponent_order }

    it 'renders the headers' do
      expect(mail.subject).to eq('Send comnponent order')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
    end
  end
end
