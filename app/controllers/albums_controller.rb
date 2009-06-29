class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.xml
  def index
    @albums = Album.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.xml
  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.xml
  def new
    if current_user
      @album = Album.new
     
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @album }
      end
    else
      render :text => "<h1>403 Forbidden</h1>", :status => 403
    end
  end

  # GET /albums/1/edit
  # def edit
  #   @album = Album.find(params[:id])
  # end

  # POST /albums
  # POST /albums.xml
  def create
    if current_user
      @album = Album.new(params[:album])
      @album.user_id = current_user.id
     
      respond_to do |format|
        if @album.save
          flash[:notice] = 'Album was successfully created.'
          format.html { redirect_to(@album) }
          format.xml  { render :xml => @album, :status => :created, :location => @album }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
        end
      end
    else
      render :text => "<h1>403 Forbidden</h1>", :status => 403
    end
  end

  # PUT /albums/1
  # PUT /albums/1.xml
  # def update
  #   @album = Album.find(params[:id])

  #   respond_to do |format|
  #     if @album.update_attributes(params[:album])
  #       flash[:notice] = 'Album was successfully updated.'
  #       format.html { redirect_to(@album) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    if current_user && current_user.privilege > 1
      @album = Album.find(params[:id])
      @album.destroy
      respond_to do |format|
        format.html { redirect_to(albums_url) }
        format.xml  { head :ok }
      end
    else
      render :text => "<h1>403 Forbidden</h1>", :status => 403
    end
  end

  # GET /albums/list/1?uid=xxx
  def list
    begin
      raise unless request.get?
      if params[:id] == "0"          # all albums
        @albums = Album.all
        render :partial => "list"
      elsif params[:id] == "1"       # albums belongs to an user
        uid = params["uid"].to_i
        raise unless uid > 0
        user = User.find uid
        @albums = user.albums
        render :partial => "list"
      elsif params[:id] == "2"    # albums not belongs to an user
        uid = params["uid"].to_i
        raise unless uid > 0
        user = User.find uid
        @albums = Album.find :all, :conditions => "user_id != #{uid}"
        render :partial => "list"
      else
        raise
      end
    rescue
      render_404
    end
  end

  def xxx
  end
end
