require 'rails_helper'

RSpec.describe MailgunService do
  let(:api_key)  { 'test-api-key' }
  let(:domain)   { 'test-domain.com' }
  let(:api_host) { 'api.eu.mailgun.net' }

  before do
    allow(Rails.application.credentials).to receive(:dig).with(:mailgun, :api_key).and_return(api_key)
    allow(Rails.application.credentials).to receive(:dig).with(:mailgun, :domain).and_return(domain)
    allow(Rails.application.credentials).to receive(:dig).with(:mailgun, :api_host).and_return(api_host)
  end

  it 'sends email without attachment' do
    mg_client = instance_double(Mailgun::Client)
    expect(Mailgun::Client).to receive(:new).with(api_key, api_host).and_return(mg_client)
    expect(mg_client).to receive(:send_message).with(domain, hash_including(:from, :to, :subject, :html))

    MailgunService.send_email(
      to: 'test@example.com',
      subject: 'Test Subject',
      html_body: '<p>Hello</p>'
    )
  end

  it 'sends email with attachment' do
    mg_client = instance_double(Mailgun::Client)
    expect(Mailgun::Client).to receive(:new).with(api_key, api_host).and_return(mg_client)
    expect(mg_client).to receive(:send_message).with(domain, hash_including(:from, :to, :subject, :html, :attachment))

    MailgunService.send_email(
      to: 'test@example.com',
      subject: 'Test Subject',
      html_body: '<p>Hello</p>',
      pdf_data: '%PDF-1.4',
      filename: 'file.pdf'
    )
  end
end
