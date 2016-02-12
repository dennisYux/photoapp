class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_fivehundredpx_access!
    if !current_fivehundredpx_access_token
      flash[:error] = 'You have to sign in with 500px account'
      redirect_to auth_fivehundredpx_path
    end
  end

  def current_fivehundredpx_access_token
    if !@current_fivehundredpx_access_token && session[:fivehundredpx_access_token_hash].present?
      @current_fivehundredpx_access_token = OAuth::AccessToken.from_hash(fivehundredpx_consumer, session[:fivehundredpx_access_token_hash])
    end
    @current_fivehundredpx_access_token
  end

  def has_fivehundredpx_access_token?
    !!current_fivehundredpx_access_token
  end

  helper_method :current_fivehundredpx_access_token
  helper_method :has_fivehundredpx_access_token?

  def fivehundredpx_consumer
    OAuth::Consumer.new(FiveHundredPX_API_CONSUMER_KEY, FiveHundredPX_API_CONSUMER_SECRET, site: FiveHundredPX_API_URL)
  end
end
