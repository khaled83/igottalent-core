class Video < ApplicationRecord
  belongs_to :user
  before_save :set_youtube_video_id, :set_live, :set_user
  self.per_page = 9

  def set_user
  end

  def set_youtube_video_id
    self.video_id = YouTube.youtube_video_id(self)
  end

  def set_live
    self.live = self.approved_admin && self.approved_user
  end
end
