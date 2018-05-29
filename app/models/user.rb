class User < ApplicationRecord
  has_many :videos
  # Creates or retrieves user form database using email as key.
  # @see: https://medium.com/@coorasse/rails-ember-google-oauth2-807e24c3266
  #
  # @param  facebook_info pair of elements retrieved from FB [access_token, User_Info]
  #           access_token: user access token received from Facebook
  #           user_info:  profile info including email, name, and picture in the format
  #                       {"email"=>"...", "name"=>"...", "picture"=>{"data"=>{"height"=>50, "is_silhouette"=>false, "url"=>"https://lookaside.facebook.com/platform/profilepic/?asid=...", "width"=>50}}, "id"=>"10154215669066942"}
  def self.from_facebook(facebook_info)
    email = facebook_info.first['email']
    find_or_create_by(email: email) do |user|
      user.name = facebook_info.first['name']
      user.image_url = facebook_info.first['picture']['data']['url']
      user.facebook_id = facebook_info.first['id']
    end
  end
end
