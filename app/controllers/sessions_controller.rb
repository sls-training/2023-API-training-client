# frozen_string_literal: true

class SessionsController < ApplicationController
  include Authenticatable

  before_action :require_not_logged_in

  def new
  end

  def create
    response = Api::AccessToken.create access_token_params.merge(grant_type: 'password', scope: 'READ WRITE')

    login response.access_token
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
    params.permit :username, :password
  end

  def require_not_logged_in
    redirect_to files_path if logged_in?
  end
end
