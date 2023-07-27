# frozen_string_literal: true

class FilesController < ApplicationController
  include Authenticatable
  include Paginatable

  before_action :require_login

  def index
    index_files_response = Api::Files.all access_token: current_access_token, **index_files_params

    @files = index_files_response[:files]
    @pagination_metadata = pagination_metadata index_files_response._headers
  rescue Flexirest::HTTPUnauthorisedClientException
    logout
    redirect_to new_session_path, status: :see_other
  rescue Flexirest::HTTPClientException, Flexirest::HTTPServerException,
         Flexirest::TimeoutException, Flexirest::ConnectionFailedException
    render_internal_server_error
  end

  private

  def index_files_params
    params.permit :page
  end

  def require_login
    redirect_to new_session_path unless logged_in?
  end

  def pagination_metadata(headers)
    {
      links: pagination_links(headers['Link'], base: Api::Files.base_url),
      page:  headers['Page'].to_i,
      per:   headers['Per'].to_i,
      total: headers['Total'].to_i
    }
  end
end
