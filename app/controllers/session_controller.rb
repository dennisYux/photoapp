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
    request_token = begin
      fivehundredpx_consumer.get_request_token(oauth_callback: FiveHundredPX_OAUTH_CALLBACK_URL)
    rescue Exception => e
      puts e.message
      puts e.backtrace.join("\n")
      nil
    end
    if request_token
      # Only store token and secret
      session[:fivehundredpx_request_token_hash] = request_token.params.to_hash
      redirect_to request_token.authorize_url
    else
      session[:fivehundredpx_request_token_hash] = nil
      # Redirect to root path to reauth
      redirect_to root_path
    end
  end

  def fivehundredpx_callback
    if session[:fivehundredpx_request_token_hash].blank? || params[:oauth_verifier].blank? 
      redirect_to root_path
      return
    end
    request_token = OAuth::RequestToken.from_hash(fivehundredpx_consumer, session[:fivehundredpx_request_token_hash])
    access_token = begin
      request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
    rescue Exception => e
      puts e.message
      puts e.backtrace.join("\n")
      nil
    end
    session[:fivehundredpx_request_token_hash] = nil
    session[:fivehundredpx_access_token_hash] = if access_token
      # Only store token and secret
      access_token.params.to_hash
    else
      nil
    end
    redirect_to root_path
  end

  # Logout all sessions
  def destroy
    session[:fivehundredpx_request_token_hash] = nil
    session[:fivehundredpx_access_token_hash] = nil
    redirect_to root_path
  end
end
