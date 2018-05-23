class VideoResource < JSONAPI::Resource
  attributes :title, :genre, :url, :approved
  has_one :user
end