# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :sessionid, uniqueness: true
  validates :access_token, presence: true, uniqueness: true

  has_secure_token :sessionid
end
