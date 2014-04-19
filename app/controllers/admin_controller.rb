class AdminController < ApplicationController
  before_action :signed_in_user, only: [:index, :active_posts, 
                          :pending_posts, :recent_comments, :users]
  before_action :admin_user, only: [:index, :active_posts, 
                          :pending_posts, :recent_comments, :users]

  def index
    @post  = current_user.posts.build                                                      
  end
  
  def active_posts
    @voted_items = Post.evaluated_by(:post_votes, current_user)    
    @feed_items = Post.where("active = ?", true).paginate(page: params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def pending_posts
    @voted_items = Post.evaluated_by(:post_votes, current_user)
    @feed_items = Post.where("active = ?", false).paginate(page: params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def recent_comments
    @voted_items = Post.evaluated_by(:post_votes, current_user)
    @feed_items = Comment.paginate(page: params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def users
    @users = User.paginate(page: params[:page], :per_page => 20)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
