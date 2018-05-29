class YouTube
  def self.youtube_video_id(video)
    regex = /(youtu.be\/|youtube.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&\"\'>]+)/
    video.url.match( regex )[5]
  end
end