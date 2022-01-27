# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    rescue_from ActiveRecord::RecordNotFound, JWT::DecodeError do
      reject_unauthorized_connection
    end

    def connect
      @jwt_token = request.params[:token]
      self.current_user = find_verified_user

      reject_unauthorized_connection unless current_user
    end

    private

    attr_reader :jwt_token

    def find_verified_user
      payload, = decode_token

      User.find(payload["id"])
    end

    def decode_token
      JWT.decode(jwt_token.to_s, Rails.application.secrets.secret_key_base)
    end
  end
end
