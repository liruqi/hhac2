class LoginController < ApplicationController
  # POST /login
  def login
    if request.post?
      @login = User.new params[:login]
      user = User.authenticate @login.uname, @login.passwd
      if user
        session[:user_id] = user.id
#        uri = session[:original_uri]
#        session[:original_uri] = nil
#        redirect_to(uri || {:controller => :users, :action => :index})
        redirect_to user
      else
        flash[:notice] = "Invalid user/password combination"
        redirect_to :controller => :login, :action => :index
      end
    end
  end

  def logout
    reset_session
    #flash[:notice] = "Logged out"
    redirect_to request.referer
  end

  # GET /login
  # GET /login/index
  def index
    @login = User.new
  end

  def loginfo
    curr_user = User.find_by_id(session[:user_id])
    render :partial => "loginfo", :locals => { :user => curr_user }
  end

  def xlogin
    @login = User.new
    render :partial => "xlogin"
  end
end
