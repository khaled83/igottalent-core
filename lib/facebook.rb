class Facebook
  # Gets engagement counts for a given video url from fb graph including likes and comments.
  # @param  video [Record]  the video being inspected for likes and comments
  def self.engagement(video)
    # get fb app access token
    @oauth = Koala::Facebook::OAuth.new(Rails.application.secrets['facebook_app_id'], Rails.application.secrets['facebook_app_secret'])
    app_access_token = @oauth.get_app_access_token
    @graph = Koala::Facebook::API.new(app_access_token)
    # get video reaction and comment count from fb
    @graph.get_object("#{Rails.application.secrets['website_url']}/videos/#{video.id}", :fields => 'engagement')
  end
end
