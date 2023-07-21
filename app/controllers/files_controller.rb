# frozen_string_literal: true

class FilesController < ApplicationController
  include Authenticatable

  before_action :require_login

  def index
    response = Api::Files.all access_token: current_access_token

    @files = response[:files]
  rescue Flexirest::HTTPClientException
    # TODO: Implement more accurate error handlings.
    logout
    redirect_to new_session_path, status: :see_other
  rescue Flexirest::HTTPServerException, Flexirest::TimeoutException, Flexirest::ConnectionFailedException
    render_internal_server_error
  end

  private

  def require_login
    redirect_to new_session_path unless logged_in?
  end
end
