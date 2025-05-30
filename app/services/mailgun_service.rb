require 'mailgun-ruby'
require 'tempfile'

class MailgunService
  def self.send_component_email(to:, subject:, html_body:, pdf_data:, filename:)
    api_key = Rails.application.credentials.dig(:mailgun, :api_key)
    domain  = Rails.application.credentials.dig(:mailgun, :domain)
    mg_host = 'api.eu.mailgun.net'
    mg_client = Mailgun::Client.new(api_key, mg_host)

    tempfile = Tempfile.new([File.basename(filename, '.pdf'), '.pdf'])
    tempfile.binmode
    tempfile.write(pdf_data)
    tempfile.rewind

    message_params = {
      from: "TGT Aluminium <postmaster@#{domain}>",
      to: to,
      subject: subject,
      html: html_body,
      attachment: tempfile
    }

    mg_client.send_message(domain, message_params)
  ensure
    tempfile.close
    tempfile.unlink
  end
end
