class Video < ApplicationRecord
  belongs_to :user
  before_save :set_youtube_video_id, :set_user

  def set_user
  end

  def set_youtube_video_id
    self.video_id = YouTube.youtube_video_id(self)
  end
end
