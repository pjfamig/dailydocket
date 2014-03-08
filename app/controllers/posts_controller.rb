class PostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :admin_user,     only: [:create, :destroy]

  def index
    if signed_in?
      @post  = current_user.posts.build                                                      
      if params[:tag]
        @feed_items = Post.tagged_with(params[:tag]).paginate(page: params[:page], 
                                                              :per_page => 20)
      else
        @feed_items = Post.paginate(page: params[:page], :per_page => 10)
      end
    end
  end
  
  def top
    #   add some more logic here: retrieve recent posts with many views and/or comments
    #   1000 views, 10 comments = 
    #   100 views, 10 comments = 
    
    if signed_in?
      @post  = current_user.posts.build         
    end
    @feed_items = Post.paginate(page: params[:page], :per_page => 10)
    render 'posts/index'   
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    post_id = params[:id]
    Post.find_by(id: params[:id]).destroy
    flash[:success] = "Post #{post_id} deleted."
    redirect_to root_url
  end
  
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.paginate(page: params[:page], :per_page => 20)
    @comment = @post.comments.build # if signed_in? => from tutorial, but
                                    # was based on user association whereas 
                                    # here we use posts
  end
  
  private

    def post_params
      params.require(:post).permit(:headline, :url, :tag_list)
    end
  
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end