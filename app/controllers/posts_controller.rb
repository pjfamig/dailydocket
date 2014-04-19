class PostsController < ApplicationController
  before_action :signed_in_user,  only: [:create, :activate, :vote, :edit, :update, :destroy]
  before_action :admin_user,      only: [:create, :activate, :edit, :update]
  before_action :superadmin_user, only: :destroy
  
  require 'will_paginate/array'
  
  def index    
    # => If render a new post form, must instantiate @post
    # => @post  = current_user.posts.build      
    # => necessary for modal?          

    # posts user has voted on
    if signed_in?
      @voted_items = Post.evaluated_by(:post_votes, current_user)
    end
                                           
    if params[:tag]
      @feed_items = Post.tagged_with(params[:tag]).paginate(page: params[:page], 
                                                              :per_page => 20)
    else
      @feed_items = Post.paginate(page: params[:page], :per_page => 10)
    end
  end
  
  def top   
    # posts user has voted on
    if signed_in?
      @voted_items = Post.evaluated_by(:post_votes, current_user)
    end 
    # => @post  = current_user.posts.build        
    @feed_items = Post.paginate(page: params[:page], :per_page => 10).popular
    render 'posts/index'   
  end
  
  def create
    @post = current_user.posts.build(post_params)
    
    # => inactive on insert
    
    if signed_in? && current_user.admin?
      @post.active = true
    end
    
    # => add some client-side validations
    
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def show
    if signed_in?
      @voted_items = Post.evaluated_by(:post_votes, current_user)
    end
    @post = Post.find(params[:id])
    @comments = @post.comments.paginate(page: params[:page], :per_page => 20)
    @comment = @post.comments.build # if signed_in? => from tutorial, but
                                    # was based on user association whereas 
                                    # here we use posts
  end
  
  def vote
    value = params[:type] == "up" ? 1 : -1
    @post = Post.find(params[:id])
    
    # => have_voted = @post.evaluators_for(:post_votes)
    
    # => unless have_voted.include?(current_user) # vote
      @post.add_or_update_evaluation(:post_votes, value, current_user)
    # => else                                      # unvote
      # => @post.delete_evaluation(:post_votes, current_user)
    # => end

    # => add conditional if logged in
    # => flash[:success] = "Thank you for voting!"
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "Post updated."
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    post_id = params[:id]
    Post.find_by(id: params[:id]).destroy
    flash[:success] = "Post #{post_id} deleted."
    redirect_to root_url
  end
    
  def activate 
    @post = Post.find(params[:id])
    @post.toggle!(:active)
    if @post.active?
      flash[:success] = "Activated."
    else
      flash[:danger] = "Deactivated."
    end
    redirect_to @post
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