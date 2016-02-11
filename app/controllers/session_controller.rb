class SessionController < ApplicationController

  def new
  end


  # There are a few gems out there for oauth integration
  # 'omniauth', 'omniauth-500px' are right fit
  # We use a fundamental gem 'oauth' to keep flexible
  # so that we are able to integrate other 3rd party services
  # even if they are not listed in omniauth yet
  def fivehundredpx_oauth
    consumer = OAuth::Consumer.new(FiveHundredPX_API_CONSUMER_KEY, FiveHundredPX_API_CONSUMER_SECRET, site: FiveHundredPX_API_URL)
    request_token = consumer.get_request_token(oauth_callback: FiveHundredPX_OAUTH_CALLBACK_URL)
    session[:request_token] = request_token
    puts "request_token: #{request_token.inspect}"
    redirect_to request_token.authorize_url
  end

  def fivehundredpx_callback
    request_token = session[:request_token]
    if request_token.blank?
      redirect_to root_path
    end
    puts "request_token: #{request_token.inspect}"
    access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
    puts "access_token: #{access_token.inspect}"
    redirect_to root_path
  end
end
