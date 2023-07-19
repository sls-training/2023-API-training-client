# frozen_string_literal: true

module Api
  class Files < Flexirest::Base
    get :all, '/files'

    before_request do |name, request|
      if name == :all
        access_token = request.get_params.delete :access_token
        request.headers['Authorization'] = "Bearer: #{access_token}"
      end
    end
  end
end
