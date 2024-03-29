# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def authorize
    unless @_user = User.find_by_id(session[:user_id])
#      session[:original_uri] = request.request_uri
      flash[:notice] = "Please login first"
      redirect_to :controller => :login, :action => :index
    end
  end

  def current_user
    @current_user = User.find_by_id session[:user_id]
  end

  def logged_in?
    @current_user != nil
  end

  helper_method :current_user, :logged_in?

  def render_404
    puts "----- #{RAILS_ROOT}/public/404.html -----"
    render :file => "#{RAILS_ROOT}/public/404.html",  :status => 404
  end

  helper_method :render_404
end
