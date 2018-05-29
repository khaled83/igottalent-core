class VideosController < JsonApiController
  before_action :authenticate_request!
  before_action :set_video, only: [:show, :update, :destroy]

  # GET /videos
  def index
    if @current_user.admin?
      @videos = Video.all
      # @videos.each do |video|
      #   video.user = User.find(video.user_id)
      # end
    else
      @videos = Video.find_by(user_id: @current_user.id) || []
    end

    jsonapi_render json: @videos
  end

  # GET /videos/1
  def show
    jsonapi_render json: @video
  end

  # POST /videos
  def create
    @video = Video.new(resource_params)
    @video.user_id = @current_user.id

    if @video.save
      jsonapi_render json: @video, status: :created
    else
      jsonapi_render_errors json: @video.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /videos/1
  def update
    if @video.update(resource_params)
      jsonapi_render json: @video
    else
      jsonapi_render_errors json: @video.errors, status: :unprocessable_entity
    end
  end

  # DELETE /videos/1
  def destroy
    @video.destroy
    head :no_content
  end

  def admin_action
    authorize! :admin
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end
end
