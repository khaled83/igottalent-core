# Background job that executes each time a video is viewed.
class VideoViewedJob < ApplicationJob
  queue_as :default

  # Updates leaderboard score with the latest counts of likes and comments on that video.
  # @params video [Record]  the video thats been viewed
  def perform(video)
    # Do something later
    Boards::UpdateService.new.video_viewed(video)
  end
end
