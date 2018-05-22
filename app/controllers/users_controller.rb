class UsersController < JsonApiController
  before_action :authenticate_request!

  def index
    render json: [{ name: 'Qui' }, { name: 'Quo' }, { name: 'Qua' }]
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
