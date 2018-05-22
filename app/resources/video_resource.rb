class VideoResource < JSONAPI::Resource
  attributes :title, :genre, :url
  has_one :user
end