# frozen_string_literal: true

class FilesController < ApplicationController
  include Sessions

  def index
    # TODO: Implement the main logic.
    reset_session_id

    Api::Files.all({ access_token: current_access_token })
  rescue Flexirest::HTTPClientException
    # TODO: Implement more accurate error handlings.
    logout
    redirect_to new_session_path, status: :see_other
  rescue Flexirest::HTTPServerException, Flexirest::TimeoutException, Flexirest::ConnectionFailedException
    render_internal_server_error
  end
end
