class UserResource < JSONAPI::Resource
  attributes :email, :name, :facebook_id, :image_url, :created_at, :updated_at
  has_many :videos
end