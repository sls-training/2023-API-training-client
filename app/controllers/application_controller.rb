# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def render_internal_server_error
    render file: Rails.root.join('public/500.html'), status: :internal_server_error,
           layout: false, content_type: 'text/html'
  end

  # #reset_session と異なりセッションIDのみをリセットする。
  def reset_session_id
    original_session = session.to_h
    reset_session
    session.update original_session
  end
end
