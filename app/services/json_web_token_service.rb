# @see: https://medium.com/@coorasse/rails-ember-google-oauth2-807e24c3266
class JsonWebTokenService
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base || ENV['SECRET_KEY_BASE'])
  end

  def self.decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base || ENV['SECRET_KEY_BASE'])[0])
  end
end