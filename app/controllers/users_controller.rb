# frozen_string_literal: true

class UsersController < ApplicationController
  def new
  end

  def create
    Api::User.create user_params

    flash[:success] = 'Your user account was created successfully'
    redirect_to login_url, status: :see_other
  rescue Flexirest::HTTPClientException => e
    @errors = e.result.errors
    render 'new', status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password
  end
end
