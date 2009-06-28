class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.find :all, :order => "created_at DESC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  # def show
  #   @comment = Comment.find(params[:id])
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @comment }
  #   end
  # end

  # GET /comments/new
  # GET /comments/new.xml
  # def new
  #   @comment = Comment.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @comment }
  #   end
  # end

  # GET /comments/1/edit
  #   def edit
  #     @comment = Comment.find(params[:id])
  #   end

  # POST /comments
  # POST /comments.xml
  # def create
  #   @comment = Comment.new(params[:comment])
  # 
  #   respond_to do |format|
  #     if @comment.save
  #       flash[:notice] = 'Comment was successfully created.'
  #       format.html { redirect_to(@comment) }
  #       format.xml  { render :xml => @comment, :status => :created, :location => @comment }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
  #     end
  #  end
  #end

  # PUT /comments/1
  # PUT /comments/1.xml
  #   def update
  #     @comment = Comment.find(params[:id])

  #     respond_to do |format|
  #       if @comment.update_attributes(params[:comment])
  #         flash[:notice] = 'Comment was successfully updated.'
  #         format.html { redirect_to(@comment) }
  #         format.xml  { head :ok }
  #       else
  #         format.html { render :action => "edit" }
  #         format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
  #       end
  #     end
  #   end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    if current_user && current_user.privilege > 1
      @comment = Comment.find(params[:id])
      @comment.destroy
     
      respond_to do |format|
#        format.html { redirect_to(comments_url) }
        format.html { redirect_to request.referer }
#        format.xml  { head :ok }
      end
    else
      render_404
    end
  end

  # GET /comments/movie/1
  def movie
    the_movie = Movie.find_by_id params[:id]
    if the_movie
      comments = Comment.find :all, :conditions => {:movie_id => the_movie.id}
      render :partial => "of_movie", :locals => {:the_movie => the_movie, :comments => comments }
    end
  end

  def xpost
    puts "------------------------------------------------------------\n\n"
    begin
      comment = Comment.new params[:comment]
      user = User.find session[:user_id]
      movie = Movie.find comment.movie_id
      raise if (comment.content =~ /^\s*$/) != nil

      comment.user_id = user.id
      comment.save
      render :text => "<script type=\"text/javascript\">alert('发表成功')</script>"
    rescue
      render :text => "<script type=\"text/javascript\">alert('发表失败')</script>"
    end
  end
end
