class SessionController < ApplicationController

  ##########
  # There are a few gems out there for oauth integration
  # 'omniauth', 'omniauth-500px' are right fit (authentication and authorization)
  # It is actually hard to build an authentication system based on oauth
  # That is what 'omniauth' for and what we would use in production environment

  # Here we use a fundamental gem 'oauth' to build oauth client
  # to demontrate the access token request process
  # The token is further stored in session object (encrypted and signed by default)
  # so that a user could interact with 500px resources without having to reauthorize
  # User expires the access token by manually logout
  def fivehundredpx_oauth
    consumer = fivehundredpx_consumer
    request_token = consumer.get_request_token(oauth_callback: FiveHundredPX_OAUTH_CALLBACK_URL)
    session[:fivehundredpx_request_token_hash] = request_token.params.to_hash
    redirect_to request_token.authorize_url
  end

  def fivehundredpx_callback
    request_token_hash = session[:fivehundredpx_request_token_hash]
    if request_token_hash.blank?
      redirect_to root_path
    end
    consumer = fivehundredpx_consumer
    request_token = OAuth::RequestToken.from_hash(consumer, request_token_hash)
    access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
    session[:fivehundredpx_request_token_hash] = nil
    session[:fivehundredpx_access_token_hash] = access_token.params.to_hash
    redirect_to root_path
  end

  # Logout all sessions
  def destroy
    session[:fivehundredpx_request_token_hash] = nil
    session[:fivehundredpx_access_token_hash] = nil
    redirect_to root_path
  end
end
