Koala.configure do |config|
  config.access_token = Rails.application.secrets['facebook_app_access_token'] || ENV['FACEBOOK_APP_ACCESS_TOKEN']
  # config.app_access_token = MY_APP_ACCESS_TOKEN
  config.app_id = Rails.application.secrets['facebook_app_id'] || ENV['FACEBOOK_APP_ID']
  config.app_secret = Rails.application.secrets['facebook_app_secret'] || ENV['FACEBOOK_APP_SECRET']
  # See Koala::Configuration for more options, including details on how to send requests through
  # your own proxy servers.
end
