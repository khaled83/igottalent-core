class VideoResource < JSONAPI::Resource
  attributes :title, :genre, :url, :approved, :user_id, :video_id
  has_one :user
end