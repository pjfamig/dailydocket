class PostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :admin_user,     only: [:create, :destroy]

  def index
    @posts = Post.paginate(page: params[:page])
  end
  
  def top
    @posts = Post.paginate(page: params[:page])    
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
    Post.find_by(id: params[:id]).destroy
    flash[:success] = "Post deleted."
    redirect_to root_url
  end
  
  private

    def post_params
      params.require(:post).permit(:headline, :url)
    end
  
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end