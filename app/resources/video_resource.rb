class VideoResource < JSONAPI::Resource
  attributes :title, :genre, :url, :approved_admin, :approved_user, :live, :video_id
  has_one :user, always_include_linkage_data: true
end