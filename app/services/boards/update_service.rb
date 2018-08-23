module Boards
  class UpdateService < Boards::Base
    def execute(entry_params)
      name = entry_params[:name]
      score = entry_params[:score].to_i

      # find existing member => UPDATE
      if leaderboard.check_member?(name)
        data = JSON.parse(leaderboard.member_data_for(name))
      # creaete new member => CREATE
      else
        id =  Redis.current.incr('id')
        user_id = User.find_by(email: name).id
        data = {id: id, user_id: user_id}
      end
      # set score
      leaderboard.rank_member(name, score, data.to_json)
      # retrieve new record
      member = leaderboard.score_and_rank_for(name)
      data = leaderboard.member_data_for(name)
      member[:page]    = leaderboard.page_for(name, leaderboard.page_size)
      member[:id]      = JSON.parse(data)['id']
      member[:user_id] = JSON.parse(data)['user_id']
      member
    end
  end
end
