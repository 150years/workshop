# frozen_string_literal: true

# app/controllers/accounts_controller.rb
class AccountsController < ApplicationController
  def index
    @accounts = Account.order(:kind, :number, :name)
  end
end
