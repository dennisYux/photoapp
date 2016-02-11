class SessionController < ApplicationController

  def new

  end


  # There are a few gems out there for oauth integration
  # 'omniauth', 'omniauth-500px' are right fit
  # We use a fundamental gem 'oauth' to keep flexible
  # so that we are able to integrate other 3rd party services
  # even if they are not listed in omniauth yet
  def fivehundredpx_oauth
    consumer = OAuth::Consumer.new(FiveHundredPX_API_CONSUMER_KEY, FiveHundredPX_API_CONSUMER_SECRET,
      site:               FiveHundredPX_API_URL,,
      request_token_path: "/oauth/request_token",
      access_token_path:  "/oauth/access_token",
      authorize_path:     "/oauth/authorize"
    )
    request_token = consumer.get_request_token(oauth_callback: OAUTH_FALLBACK_URL)
    # TODO store request token
    redirect_to request_token.authorize_url(oauth_callback: OAUTH_FALLBACK_URL)
  end
end
