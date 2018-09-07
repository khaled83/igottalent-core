module Boards
  class UpdateService < Boards::Base
    # Updates score for a given user.
    # Scenario 1: score is defined by absolute value => overrides existing value.
    # Scenario 2: pass the number of FB likes and comments and calculate the score.
    def execute(entry_params)
      name  = entry_params[:name]
      score = entry_params[:score].to_i
      # create entry if it doesn't exist
      find_or_create(name)
      # rank member with the new score
      leaderboard.rank_member(name, score)
      # return json friendly object
      json_friendly(name)
    end

    # Finds existing leaderboard member or creates a new entry if none exists.
    def find_or_create(name)
      unless leaderboard.check_member?(name)
        id            =  Redis.current.incr('id')
        user_id       = User.find_by(email: name).id
        member_data   = {id: id, user_id: user_id, total_reaction_count: 0, total_comment_count: 0, total_video_count: 0}
        leaderboard.rank_member(name, 0, member_data.to_json)
      end
      leaderboard.score_and_rank_for(name)
    end

    # Executed after video is created (video#create).
    # User's total video count and leaderboard score are incremented.
    def video_created(video)
      name = member_name(video)
      find_or_create(name)
      member_data = member_data(name)
      # update member data and score
      member_data['total_video_count'] += 1
      leaderboard.rank_member(name, score(member_data['total_reaction_count'], member_data['total_comment_count'], member_data['total_video_count']), member_data.to_json)
      json_friendly(name)
    end

    # Executed after video is viewed (video#show).
    # Video like and comment counts possibly changed after viewing the video.
    # Recaculate user score based on the latest counts from FB.
    def video_viewed(video)
      # get video reaction and comment count from fb
      engagement      = Facebook.engagement(video)
      comment_count   = engagement['engagement']['comment_plugin_count']
      reaction_count  = engagement['engagement']['reaction_count']
      # find old count of reaction and comment
      old_reaction_count  = video.reaction_count
      old_comment_count   = video.comment_count
      # update video with the new like and comment counts
      video.update(reaction_count: reaction_count, comment_count: comment_count)
      # increment reaction and comment count based on the latest values from fb
      name = member_name(video)
      member_data = member_data(name)
      total_video_count     = video.user.videos.count
      total_reaction_count  = member_data['total_reaction_count'] + reaction_count - old_reaction_count
      total_comment_count   = member_data['total_comment_count']  + comment_count  - old_comment_count
      # score formula
      member_data['total_reaction_count'] = total_reaction_count
      member_data['total_comment_count']  = total_comment_count
      Rails.logger.info "old_reaction_count=#{old_reaction_count} old_comment_count=#{old_comment_count}"
      Rails.logger.info "engagement=#{engagement}"
      Rails.logger.info "member_data=#{member_data}"
      Rails.logger.info("total_video_count =#{total_video_count} total_reaction_count =#{total_reaction_count} total_comment_count =#{total_comment_count} score = #{score(total_video_count, total_reaction_count, total_comment_count)}")
      leaderboard.rank_member(name, score(total_video_count, total_reaction_count, total_comment_count), member_data.to_json)
      # return result
      json_friendly(name)
    end

    private

    # return member name for the given video
    def member_name(video)
      User.find(video.user_id).email
    end

    # Return parsed member data as Hash for the given name
    def member_data(name)
      JSON.parse(leaderboard.member_data_for(name))
    end

    # Get json-api friendly leaderboard member by including page, id, and user_id attributes.
    def json_friendly(name)
      member            = leaderboard.score_and_rank_for(name)
      member_data       = member_data(name)
      member[:page]     = leaderboard.page_for(name, leaderboard.page_size)
      member[:id]       = member_data['id']
      member[:user_id]  = member_data['user_id']
      member
    end

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
