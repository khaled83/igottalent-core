class UsersController < JsonApiController
  before_action :authenticate_request!
  before_action :set_video, only: [:update]

  def index
    render json: [{ name: 'Qui' }, { name: 'Quo' }, { name: 'Qua' }]
  end

  def me
    jsonapi_render json: @current_user
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(resource_params)
      jsonapi_render json: @user
    else
      jsonapi_render_errors json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @user = User.find(params[:id])
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
