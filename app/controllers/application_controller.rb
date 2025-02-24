# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  include Pagy::Backend

  before_action :authenticate_user!

  helper_method :current_company

  private

  def current_company
    @current_company ||= current_user.company
  end
end
