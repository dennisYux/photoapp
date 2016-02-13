class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if Rails.env.production?
    rescue_from Exception, :with => :render_global_error
  end

  def authenticate_fivehundredpx_access!
    if !current_fivehundredpx_access_token
      respond_to do |format| 
        format.html {redirect_to auth_fivehundredpx_path}
        format.all  {render json: {message: 'You have to sign in with 500px account'}, :status => 401}
      end
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

  # Respond to global exception
  def render_global_error(e)
    puts e.message + "\n " + e.backtrace.join("\n ")

    respond_to do |format| 
      format.html {render file: 'public/404.html', :status => 404}
      format.all  {render json: {message: 'exception occurred'}, :status => 404}
    end
  end
end
