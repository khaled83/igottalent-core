class LeaderboardEntriesController < JsonApiController
  before_action :authenticate_request!

  # this action is not tested
  def show
    # placeholder code
    jsonapi_render_errors status: :unprocessable_entity
    # original code
    # @entry = retrieve_service.execute(name: params[:id])
    # return not_found unless @entry
    # jsonapi_render json: @entry
  end

  def create
    Rails.logger.info "resource_params: #{resource_params}"
    @entry = create_service.execute(resource_params)
    if @entry
      jsonapi_render json: to_entity(@entry), status: :created
    else
      jsonapi_render_errors status: :unprocessable_entity
    end
  end

  def index
    @entries = retrieve_all_service.execute
    jsonapi_render json: to_entities(@entries), status: :ok
  end

  def destroy
    if delete_service.execute(params)
      head :no_content
    else
      jsonapi_render_errors json: [{ id: 'validation', title: "User (id: #{params[:id]}) or user's leaderboard entry not found."}], status: :not_found
    end
  end

  private

  def to_entity(member)
    OpenStruct.new(:id => member[:id], :name => member[:member], :score => member[:score],
                   :rank => member[:rank], :user_id => member[:user_id])
  end

  def to_entities(members)
    entities = []
    members.each do |member|
      entities << to_entity(member)
    end
    entities
  end

  def create_service
    Boards::UpdateService.new
  end

  def retrieve_service
    Boards::GetService.new
  end

  def retrieve_all_service
    Boards::GetAllService.new
  end

  def delete_service
    Boards::DeleteService.new
  end

  def entry_params
    (params[:entry] || {}).slice(:name, :score)
  end
end
