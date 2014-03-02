class StaticPagesController < ApplicationController
#   NOTE: I moved the root logic to the posts controller.
#   staticpages#home no longer matters 
#   unless the user is not logged in at all (which I'm also going to change)
#   I'll keep this stuff in tact in case I need to revert later for some reason. 

  def home
    if signed_in?
      @post  = current_user.posts.build
      @feed_items = Post.paginate(page: params[:page], :per_page => 20)
    end
  end

  def about
  end

  def rules
  end
end
