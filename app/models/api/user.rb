# frozen_string_literal: true

module Api
  class User < Flexirest::Base
    post :create, 'user'
  end
end
