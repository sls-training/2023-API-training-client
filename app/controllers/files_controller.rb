# frozen_string_literal: true

class FilesController < ApplicationController
  include Authenticatable

  before_action :require_login

  def index
    index_files_response = Api::Files.all access_token: current_access_token

    @files = index_files_response[:files]
  rescue Flexirest::HTTPClientException => e
    if e.status == 401 && e.result&.error == 'invalid_token'
      logout
      redirect_to new_session_path, status: :see_other
    else
      render_internal_server_error
    end
  rescue Flexirest::HTTPServerException, Flexirest::TimeoutException, Flexirest::ConnectionFailedException
    render_internal_server_error
  end

  private

  def require_login
    redirect_to new_session_path unless logged_in?
  end
end
