# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :confirm_password, only: %i[create]

  def new
  end

  def create
    Api::User.create user_params

    flash[:success] = 'Your user account was created successfully'
    redirect_to new_session_path, status: :see_other
  rescue Flexirest::HTTPClientException => e
    @errors = e.result.errors
    render 'new', status: :unprocessable_entity
  rescue Flexirest::HTTPServerException, Flexirest::TimeoutException, Flexirest::ConnectionFailedException
    render_internal_server_error
  end

  private

  def user_params
    params.permit :name, :email, :password
  end

  def confirm_password
    return if params[:password] == params[:password_confirmation]

    @errors = [{ 'name' => 'password_confirmation', 'reason' => "doesn't match with password" }]
    render 'new', status: :unprocessable_entity
  end
end
