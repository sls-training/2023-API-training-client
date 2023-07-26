# frozen_string_literal: true

module Api
  class AccessToken < Flexirest::Base
    post :create, '/signin', defaults: { grant_type: 'password', scope: 'READ WRITE' }
  end
end
