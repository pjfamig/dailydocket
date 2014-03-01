class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @post  = current_user.posts.build
      @feed_items = Post.paginate(page: params[:page])
    end
  end

  def about
  end

  def rules
  end
end
