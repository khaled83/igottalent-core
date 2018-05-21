class UsersController < ApplicationController
  before_action :authenticate_request!

  def index
    render json: [{ name: 'Qui' }, { name: 'Quo' }, { name: 'Qua' }]
  end

  private

  def authenticate_request!
      # byebug
    if valid_token?
      @current_user = User.find(auth_token[:user_id].second)
    else
      render json: {}, status: :unauthorized
    end
  rescue JWT::VerificationError, JWT::DecodeError, Omniauth::ResponseError, Omniauth::PermissionError
    render json: {}, status: :unauthorized
  end

  private

  def valid_token?
    request.headers['Authorization'].present? && auth_token.present?
  end

  private

  def valid_token?
    request.headers['Authorization'].present? && auth_token.present?
  end

  def auth_token
    @auth_token ||= JsonWebTokenService.decode(request.headers['Authorization'].split(' ').last)
  end

  # def auth_token
  #   # user_info, access_token = Omniauth::Facebook.authenticate(params['code'])
  #   info = Omniauth::Facebook.authenticate(params['code'])
  #   user = User.from_facebook(info)
  #
  #   if user['email'].blank?
  #     Omniauth::Facebook.deauthorize(access_token)
  #   end
  #   return user
  #   # @auth_token ||= JsonWebTokenService.decode(request.headers['Authorization'].split(' ').last)
  # end
end
