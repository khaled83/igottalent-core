class VideoCreatedJob < ApplicationJob
  queue_as :default

  # Updates leaderboard score with the latest count of videos
  # @param  video [Record]  the video thats been created
  def perform(video)
    # Do something later
    Boards::UpdateService.new.video_created(video)
  end
end
