# frozen_string_literal: true

# Controller which other controllers Inherit from
class ApplicationController < ActionController::API
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def authenticate_user
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split.second
      begin
        jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first

        @current_user_id = jwt_payload["id"]
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    end
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end
end
