# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@aluworkshop.com'
  layout 'mailer'
end
