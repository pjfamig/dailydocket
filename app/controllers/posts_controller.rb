class PostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :admin_user,     only: [:create, :destroy]
  require 'will_paginate/array'
  
  def index    
    if signed_in?
      @post  = current_user.posts.build                                                      
      if params[:tag]
        @feed_items = Post.tagged_with(params[:tag]).paginate(page: params[:page], 
                                                              :per_page => 20)
      else
        @feed_items = Post.paginate(page: params[:page], :per_page => 10)
      end
      
    else
      # add redirect for main index path
    end
  end
  
  def top    
    if signed_in?
      @post  = current_user.posts.build  
      
      #post_ids = ActiveRecord::Base.connection.execute("SELECT target_id FROM rs_reputations WHERE target_type = 'Post' ORDER BY value DESC")
      #post_ids = post_ids.map { |item| item = item[0] }
      #@feed_items = []
      #post_ids.each { |id| @feed_items << Post.find(id) }
      #@feed_items = @feed_items.paginate(page: params[:page], :per_page => 10)      
      
      @feed_items = Post.paginate(page: params[:page], :per_page => 10).popular
      
      render 'posts/index'   
    else
      flash[:warning] = "Please sign in."
      redirect_to signin_path
    end
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
  

  def vote
    value = params[:type] == "up" ? 1 : -1
    @post = Post.find(params[:id])
    @post.add_or_update_evaluation(:post_votes, value, current_user)
    flash[:success] = "Thank you for voting!"
    redirect_to :back
  end

  
  private

    def post_params
      params.require(:post).permit(:headline, :url, :tag_list, :image, :remote_image_url)
    end
  
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end