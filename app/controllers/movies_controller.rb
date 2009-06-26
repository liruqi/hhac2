class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.xml
  def index
    @movies = Movie.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movies }
      format.js { render :text => @movies.to_json }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
      format.js { render :text => @movie.to_json }
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  #def new
  #  if current_user
  #    @movie = Movie.new
  #    respond_to do |format|
  #      format.html # new.html.erb
  #    # format.xml  { render :xml => @movie }
  #    end
  #  else
  #   render_404
  #  end
  #end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
    unless current_user && (current_user.privilege>1 || current_user.id==@movie.user_id)
      render_404
    end
  end

  # POST /movies
  # POST /movies.xml
  #def create
  #  if current_user
  #    @movie = Movie.new(params[:movie])
  #   
  #    respond_to do |format|
  #      if @movie.save
  #        flash[:notice] = 'Movie was successfully created.'
  #        format.html { redirect_to(@movie) }
  #        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
  #      else
  #        format.html { render :action => "new" }
  #        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
  #      end
  #    end
  #  else
  #   render_404
  #  end
  #end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = Movie.find(params[:id])
    if current_user && (current_user.privilege>1 || current_user.id==@movie.id)
      respond_to do |format|
        if @movie.update_attributes(params[:movie])
          flash[:notice] = 'Movie was successfully updated.'
          format.html { redirect_to(@movie) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
        end
      end
    else
      render_404
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    if current_user && current_user.privilege > 1
      @movie = Movie.find(params[:id])
      File.delete @movie.path
      @movie.destroy
     
      respond_to do |format|
        format.html { redirect_to(movies_url) }
        format.xml  { head :ok }
      end
    else
      render_404
    end
  end

  # GET /movies/stream/1
  def stream
    begin
      @movie = Movie.find(params[:id])
      send_file @movie.path,
                :type => "video/x-flv",
                :disposition => "inline",
                :stream => true
    rescue
      render_404
    end
  end

  def upload
    if current_user
      @movie = Movie.new
    else
      render_404
    end
  end

  def save
    if current_user
      begin
        movie = Movie.new params[:movie]
        raise "Title cannot be empty." if (movie.title =~ /^\s*$/) != nil

        file = params[:file]  # Tempfile实例
        raise "File was not uploaded." if file == nil

        begin
          fname = Time.now.strftime("%Y%m%d%H%M%S")+"_"+file.original_filename
          f = File.new "#{RAILS_ROOT}/public/upload/#{fname}", 'wb'
          f.write file.read

          movie.path = f.path
          movie.user_id = current_user.id
          movie.album_id = 1
          movie.save
        rescue
          raise "Failed to save data."
        end

        redirect_to movie
      rescue
        render :text => "Upload failed.\nException: #{$!.message}\n", :status => 500
      end
    else
      render :text => "Upload failed.\n403 Forbidden", :status => 403
    end
  end

  def info
    @movie = Movie.find_by_id params[:id]
    render :partial => "info"
  end

  def list
    begin
      raise "id must be select" if params[:id] != "select"
      user_id = params[:user_id]
      album_id = params[:album_id]
      if user_id
        user = User.find user_id
        @movies = user.movies
      elsif album_id
        album = Album.find album_id
        @movies = album.movies
      else
        @movies = Movie.all
      end
      render :partial => "list"
    rescue
      render :text=>"Exception: #{$!}"
      # render_404
    end
  end
end
