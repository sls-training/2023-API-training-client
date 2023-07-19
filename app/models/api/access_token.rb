# frozen_string_literal: true

module Api
  class AccessToken < Flexirest::Base
    post :create, '/signin'
  end
end
