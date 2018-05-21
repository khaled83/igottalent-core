class TokensController < ApplicationController
  # Called when user logs in with Facebook on the frontend.
  #
  # Flow:
  # 1. Authenticates user using FB code passed from the frontend
  # 2. Retrieves user FB profile info including email
  # 3. Creates or retrieves user from DB using email as key
  #
  # @see: https://medium.com/@coorasse/rails-ember-google-oauth2-807e24c3266
  def create
    info = Omniauth::Facebook.authenticate(params['code'])
    user = User.from_facebook(info)
    render json: payload(user), status: :ok
  end

  private

  def payload(user)
    { access_token: JsonWebTokenService.encode(user_id: user.id), user: user }
  end
end
