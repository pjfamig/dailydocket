class CommentsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to post_path(@post)
    else
      # => flash[:danger] = "Comment cannot be blank!"
      # => redirect_to post_path(@post)
      @comments = @post.comments.paginate(page: params[:page], :per_page => 5)
      render 'posts/show' # => Renders but does not display errors???
    end
  end

  def destroy
    @comment.destroy
    @post = Post.find(params[:post_id])
    flash[:success] = "Comment deleted."
    redirect_to post_path(@post)
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end