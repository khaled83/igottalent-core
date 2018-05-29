class VideoResource < JSONAPI::Resource
  attributes :title, :genre, :url, :approved, :user_id, :video_id
  has_one :user, always_include_linkage_data: true
end