# frozen_string_literal: true

class FilesController < ApplicationController
  def index
    # TODO: Implement the main logic.
    reset_session_id

    Api::Files.all({ access_token: session[:access_token] })
  rescue Flexirest::HTTPClientException
    # TODO: Implement more accurate error handlings.
    session.delete :access_token
    redirect_to new_session_path, status: :see_other
  rescue Flexirest::HTTPServerException, Flexirest::TimeoutException, Flexirest::ConnectionFailedException
    render_internal_server_error
  end
end
