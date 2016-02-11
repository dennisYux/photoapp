class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_fivehundredpx_access!
    if !current_fivehundredpx_access_token
      redirect_to fivehundredpx_oauth_path
    end
  end

  def current_fivehundredpx_access_token
    session[:fivehundredpx_access_token]
  end

  def has_fivehundredpx_access_token?
    !!current_fivehundredpx_access_token
  end

  helper_method :current_fivehundredpx_access_token
  helper_method :has_fivehundredpx_access_token?
end
