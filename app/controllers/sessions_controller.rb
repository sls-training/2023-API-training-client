# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :logged_in_user

  def new
  end

  def create
    response = Api::AccessToken.create access_token_params
                                         .transform_keys { |k| k == :email ? :username : k }
                                         .merge(grant_type: 'password', scope: 'READ WRITE')

    session[:access_token] = response.access_token
    flash[:success] = 'You logged in successfully'
    redirect_to files_path, status: :see_other
  rescue Flexirest::HTTPClientException => e
    if e.result.error == 'invalid_request'
      @errors = [{ 'name' => 'email, password or both', 'reason' => 'are invalid' }]
      render 'new', status: :unprocessable_entity
    else
      render_internal_server_error
    end
  rescue Flexirest::HTTPServerException, Flexirest::TimeoutException, Flexirest::ConnectionFailedException
    render_internal_server_error
  end

  private

  def access_token_params
    params.permit :email, :password
  end

  def logged_in_user
    redirect_to files_path if session[:access_token].present?
  end
end
