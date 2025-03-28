# frozen_string_literal: true 

class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  # GET /clients
  def index
    @clients = current_company.clients.all
  end

  # GET /clients/1
  def show; end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit; end

  # POST /clients
  def create
    @client = Client.new(client_params)
    @client.company = current_company

    if @client.save
      redirect_to @client, notice: 'Client was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      redirect_to clients_path, notice: 'Client was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy!
    redirect_to clients_path, notice: 'Client was successfully destroyed.', status: :see_other
  end

  private

  def set_client
    @client = current_company.clients.find(params.expect(:id))
  end

  def client_params
    params.fetch(:client, {}).permit(:name, :phone, :email, :address, :tax_id)
  end
end
