# frozen_string_literal: true

class AgentsController < ApplicationController
  before_action :set_agent, only: %i[show edit update destroy]

  # GET /agents
  def index
    @agents = current_company.agents
  end

  # GET /agents/1
  def show; end

  # GET /agents/new
  def new
    @agent = Agent.new
  end

  # GET /agents/1/edit
  def edit; end

  # POST /agents
  def create
    @agent = Agent.new(agent_params)
    @agent.company = current_company

    if @agent.save
      redirect_to @agent, notice: 'Agent was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agents/1
  def update
    if @agent.update(agent_params)
      redirect_to agents_path, notice: 'Agent was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /agents/1
  def destroy
    @agent.destroy!
    redirect_to agents_path, notice: 'Agent was successfully destroyed.', status: :see_other
  end

  private

  def set_agent
    @agent = current_company.agents.find(params.expect(:id))
  end

  def agent_params
    params.fetch(:agent, {}).permit(:name, :phone, :email, :commission, :passport, :workpermit)
  end
end
