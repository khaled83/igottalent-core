class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found

  private

  def authenticate_request!
    if valid_token?
      @current_user = User.find(auth_token[:user_id].second)
    else
      render json: {}, status: :unauthorized
    end
  rescue JWT::VerificationError, JWT::DecodeError, Omniauth::ResponseError, Omniauth::PermissionError
    render json: {}, status: :unauthorized
  end

  def valid_token?
    request.headers['Authorization'].present? && auth_token.present?
  end

  def auth_token
    @auth_token ||= JsonWebTokenService.decode(request.headers['Authorization'].split(' ').last)
  end
end
