module Boards
  class UpdateService < Boards::Base
    # Updates score for a given user.
    # Scenario 1: score is defined by absolute value => overrides existing value.
    # Scenario 2: pass the number of FB likes and comments and calculate the score.
    def execute(entry_params)
      name = entry_params[:name]
      # UPDATE existing member
      if leaderboard.check_member?(name)
        data = JSON.parse(leaderboard.member_data_for(name))
      # CREATE new member
      else
        id =  Redis.current.incr('id')
        user_id = User.find_by(email: name).id
        data = {id: id, user_id: user_id, total_reaction_count: 0, total_comment_count: 0, total_video_count: 0}
      end
      score = entry_params[:score].to_i
      # create/update member
      leaderboard.rank_member(name, score, data.to_json)
      member = leaderboard.score_and_rank_for(name)
      data = leaderboard.member_data_for(name)
      member[:page]    = leaderboard.page_for(name, leaderboard.page_size)
      member[:id]      = JSON.parse(data)['id']
      member[:user_id] = JSON.parse(data)['user_id']
      member
    end

    # Executed after video#show.
    # Video like and comment counts possibly changed after viewing the video.
    # Recaculate user score based on the latest counts from FB.
    def video_viewed(video)
      # get video reaction and comment count from fb
      # get fb app access token
      @oauth = Koala::Facebook::OAuth.new(Rails.application.secrets['facebook_app_id'], Rails.application.secrets['facebook_app_secret'])
      app_access_token = @oauth.get_app_access_token
      @graph = Koala::Facebook::API.new(app_access_token)
      engagement = @graph.get_object("#{Rails.application.secrets['website_url']}/videos/#{video.id}", :fields => 'engagement')
      Rails.logger.info engagement
      comment_count   = engagement['engagement']['comment_plugin_count']
      reaction_count  = engagement['engagement']['reaction_count']
      # find old count of reaction and comment
      old_reaction_count  = video.reaction_count
      old_comment_count   = video.comment_count
      # update video with the new like and comment counts
      video.update(reaction_count: reaction_count, comment_count: comment_count)
      # increment reaction and comment count based on the latest values from fb
      name = User.find(video.user_id).email
      data = JSON.parse(leaderboard.member_data_for(name))
      # debugger
      total_reaction_count  = data['total_reaction_count'] + reaction_count - old_reaction_count
      total_comment_count   = data['total_comment_count']  + comment_count  - old_comment_count
      total_video_count     = data['total_video_count']
      # score formula
      data['total_reaction_count'] = total_reaction_count
      data['total_comment_count']  = total_comment_count
      leaderboard.rank_member(name, score(total_video_count, total_reaction_count, total_comment_count), data.to_json)
      # return score and rank member
      leaderboard.score_and_rank_for(name)
    end

    private

    # Calculates leaderboard score value.
    # Simply adds up all the counts together.
    # @param total_video_count  [integer] number of videos posted by user
    # @param total_reaction_count [integer] number of likes over all user videos
    # @param total_comment_count  [integer] number of comments over all user videos
    def score(total_video_count, total_reaction_count, total_comment_count)
      total_video_count + total_reaction_count + total_comment_count
    end
  end
end
