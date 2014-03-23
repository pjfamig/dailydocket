class AdminController < ApplicationController
  before_action :signed_in_user, only: :index
  before_action :admin_user, only: :index

  def index
    @feed_items = Post.paginate(page: params[:page], :per_page => 10)
    @post  = current_user.posts.build                                                      
 
  end
  
  def live_posts
    @feed_items = Post.paginate(page: params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def pending_posts
    @data = "Pending Posts (Ajax)"
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def recent_comments
    @data = "Recent Comments (Ajax)"
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def users
    @users = User.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
