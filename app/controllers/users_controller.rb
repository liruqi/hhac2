class UsersController < ApplicationController
  before_filter :authorize, :except => [:new, :create]

  # GET /users
  # GET /users.xml
  def index
    p current_user
    if current_user.privilege < 2
        redirect_to current_user 
      return
    end

    @users = User.all

    if current_user.privilege < 3
      for user in @users
        next if user.id == current_user.id
        user.passwd = "********"
      end
    end

    if current_user.privilege < 2
      for user in @users
        next if user.id == current_user.id
        user.email = "********"
        user.utype = "********"
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    begin
      raise if current_user.id != params[:id].to_i && current_user.privilege < 2

      @user = User.find(params[:id])
     
      if current_user.privilege < 3 && @user.id != current_user.id
        @user.passwd = "********"
      end
     
      if current_user.privilege < 2 && @user.id != current_user.id
        @user.email = "********"
        @user.utype = "********"
      end
     
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    rescue
      redirect_to "/404.html"
    end
  end

  # GET /users/new
  # GET /users/new.xml
  # 只有guest和admin可以访问此页面
  def new
    user = current_user
    if user == nil || user.privilege == 3
      @user = User.new
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @user }
      end
    else
      flash[:notice] = "You are not privileged to do this"
      redirect_to (request.referer || current_user)
    end
  end

  # GET /users/1/edit
  # 用户信息一旦创建将不可修改；但admin可以修改任何用户的信息
  def edit
    if current_user.privilege == 3
      @user = User.find(params[:id])
    else
      flash[:notice] = "User information cannot be modified."
      redirect_to request.referer
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.utype = "member"

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  # 用户信息一旦创建将不可修改；但admin可以修改任何用户的信息
  def update
    if current_user.privilege == 3
      @user = User.find(params[:id])
     
      respond_to do |format|
        if @user.update_attributes(params[:user])
          flash[:notice] = 'User was successfully updated.'
          format.html { redirect_to(@user) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:notice] = "User information cannot be modified."
      redirect_to request.referer
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    user = current_user
    if user.privilege == 3 && user.id != params[:id].to_i
      @x_user = User.find(params[:id])
      x_user_uname = @x_user.uname
      @x_user.destroy
     
      flash[:notice] = "User `#{x_user_uname}` has been permanently deleted."
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      end
    else
      flash[:notice] = "You are not privileged to do this"
      redirect_to request.referer
    end
  end

  def xregister
    @user = User.new
    render :partial => "xregister"
  end
end
