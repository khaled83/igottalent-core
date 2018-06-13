require 'httparty'

module Omniauth

  # @see
  # https://stackoverflow.com/questions/19989391/authenticate-user-using-omniauth-and-facebook-for-a-rails-api
  # https://gist.github.com/mad-raz/a60714f968e1178f0717
  class Facebook
    include HTTParty

    # The base uri for facebook graph API
    base_uri 'https://graph.facebook.com/v3.0'

    # Used to authenticate app with facebook user
    # Usage
    #   Omniauth::Facebook.authenticate('authorization_code')
    # Flow
    #   Retrieve access_token from authorization_code
    #   Retrieve User_Info hash from access_token
    def self.authenticate(code)
      provider = self.new
      access_token = provider.get_access_token(code)
      user_info    = provider.get_user_profile(access_token)

      return user_info, access_token
    end

    # Used to revoke the application permissions and login if a user
    # revoked some of the mandatory permissions required by the application
    # like the email
    # Usage
    #    Omniauth::Facebook.deauthorize('user_id')
    # Flow
    #   Send DELETE /me/permissions?access_token=XXX
    def self.deauthorize(access_token)
      options  = { query: { access_token: access_token } }
      response = self.delete('/me/permissions', options)

      # Something went wrong most propably beacuse of the connection.
      unless response.success?
        Rails.logger.error 'Omniauth::Facebook.deauthorize Failed'
        fail Omniauth::ResponseError, 'errors.auth.facebook.deauthorization'
      end
      response.parsed_response
    end

    def get_access_token(code)
      # byebug
      # code = 'AQCJ9oMj9dDPSo0gkPDSLGR3Ny6mCZLtjiniO686C8a1yZf9mQKSjz-nIV3vtUDvjgLE8xl4n6UH4fLO3MwfuCcAnJ-XYST01pnvBGa737tqr2HjKAgxF7p0d-v0Jz22pawCXWnrlM8DPaMI2zGXLh1ivHUTUTNoAo_w4KI7fLDSeVLbyieEvm_9xNtFsqjk-p62-D4rxKUVNmhIB-M366sC7wQWkP1YhPPvrfPE8SVnsuAI-VWlACH64C5GAQlCL438DXj7s1saGXjwEn3gjyickZYF1MAeC6tlsiQL9HyP65XnzFrTC-QTrsXU1HNkebA'
      response = self.class.get('/oauth/access_token', query(code))
      Rails.logger.info "res: #{response.body}"

      # Something went wrong either wrong configuration or connection
      unless response.success?
        Rails.logger.error 'Omniauth::Facebook.get_access_token Failed'
        fail Omniauth::ResponseError, 'errors.auth.facebook.access_token'
      end
      response.parsed_response['access_token']
    end

    def get_user_profile(access_token)
      # fields: https://developers.facebook.com/docs/facebook-login/permissions/v3.0
      options = { query: { access_token: access_token, fields: 'email,name,picture'} }
      response = self.class.get('/me', options)

      # Something went wrong most propably beacuse of the connection.
      unless response.success?
        Rails.logger.error 'Omniauth::Facebook.get_user_profile Failed'
        fail Omniauth::ResponseError, 'errors.auth.facebook.user_profile'
      end
      response.parsed_response
    end

    private

    # access_token required params
    # https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/v2.3#confirm
    def query(code)
      {
          query: {
              code: code,
              redirect_uri: 'http://localhost:4200/torii/redirect.html',
              client_id: Rails.application.secrets['facebook_app_id'] || ENV['FACEBOOK_APP_ID'],
              client_secret: Rails.application.secrets['facebook_oauth_secret'] || ENV['FACEBOOK_SECRET']
          }
      }
    end
  end
end