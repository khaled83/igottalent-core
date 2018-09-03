# @unused @deprecated @todo remove?
class LeaderboardsController < ApplicationController
  before_action :query_options

  def show
    @lb = Boards.default_leaderboard
    @entries = entry_service.execute(query_options)
    jsonapi_render json: @entries
  end

  private

  def paginate
    pager = Kaminari.paginate_array(
      @entries,
      total_count: @lb.total_members)

    @page_array = pager.page(@page).per(@limit)
  end

  def entry_service
    Boards::GetAllService.new
  end
end
