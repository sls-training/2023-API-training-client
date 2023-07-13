# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def render_internal_server_error
    render file: Rails.root.join('public/500.html'), status: :internal_server_error,
           layout: false, content_type: 'text/html'
  end
end
