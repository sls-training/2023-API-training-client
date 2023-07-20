# frozen_string_literal: true

module Authenticatable
  def login(access_token)
    session[:access_token] = access_token
  end

  def logout
    session.delete :access_token
  end

  def logged_in?
    session[:access_token].present?
  end

  def current_access_token
    session[:access_token]
  end
end
