class CommentsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :vote, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(:parent_id => params[:parent_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.html { redirect_to post_path(@post) }
        format.js
      end
      # => flash[:success] = "Comment created!" 
      # => redirect_to post_path(@post)   
    else
      @comments = @post.comments.paginate(page: params[:page], :per_page => 20)
      render 'posts/show'
    end
  end

  def destroy
    @comment.destroy
    @post = Post.find(params[:post_id])
    flash[:success] = "Comment deleted."
    redirect_to post_path(@post)
  end
  
  def vote
    value = params[:type] == "up" ? 1 : -1
    @comment = Comment.find(params[:id])
    @comment.add_or_update_evaluation(:comment_votes, value, current_user)
    flash[:success] = "Thank you for voting!"
    redirect_to :back
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :parent_id)
    end
    
    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end