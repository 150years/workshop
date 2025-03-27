# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users
  def index
    # @users = current_company.users
    @search = current_company.users.ransack(params[:q])
    @pagy, @users = pagy(@search.result(distinct: true))
  end

  # GET /users/1
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.company = current_company

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
    redirect_to users_path, notice: 'User was successfully destroyed.', status: :see_other
  end

  private

  def set_user
    @user = current_company.users.find(params.expect(:id))
  end

  def user_params
    # Do not change password if it is blank. Used in Edit action.
    params[:user].delete(:password) if params[:user][:password].blank?

    params.fetch(:user, {}).permit(:name, :email, :password)
  end
end
