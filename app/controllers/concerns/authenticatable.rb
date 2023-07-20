# frozen_string_literal: true

module Authenticatable
  def login(access_token)
    reset_session
    session[:access_token] = access_token
  end

  def logout
    reset_session
  end

  def logged_in?
    session[:access_token].present?
  end

  def current_access_token
    session[:access_token]
  end
end
