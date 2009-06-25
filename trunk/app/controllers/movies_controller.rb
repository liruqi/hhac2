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
  #    redirect_to '/404.html'
  #  end
  #end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
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
  #    redirect_to '/404.html'
  #  end
  #end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = Movie.find(params[:id])

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
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.find(params[:id])
    File.delete @movie.path
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
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
      path404 = File.join File.dirname(__FILE__), "../../public/404.html"
      render :file => path404, :status => 404
    end
  end

  def upload
    if current_user
      @movie = Movie.new
    else
      redirect_to '/404.html'
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
end
