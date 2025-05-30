# frozen_string_literal: true

require 'mailgun-ruby'
require 'tempfile'

class MailgunService
  def self.send_email(to:, subject:, html_body:, pdf_data: nil, filename: nil) # rubocop:disable Metrics/MethodLength
    api_key = Rails.application.credentials.dig(:mailgun, :api_key)
    domain  = Rails.application.credentials.dig(:mailgun, :domain)
    mg_host = Rails.application.credentials.dig(:mailgun, :api_host)
    mg_client = Mailgun::Client.new(api_key, mg_host)

    message_params = {
      from: "TGT Aluminium <postmaster@#{domain}>",
      to: to,
      subject: subject,
      html: html_body
    }

    if pdf_data && filename
      tempfile = Tempfile.new([File.basename(filename, '.pdf'), '.pdf'])
      tempfile.binmode
      tempfile.write(pdf_data)
      tempfile.rewind
      message_params[:attachment] = tempfile
    end

    mg_client.send_message(domain, message_params)
  ensure
    if tempfile
      tempfile.close
      tempfile.unlink
    end
  end
end
