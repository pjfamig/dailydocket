class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:index, :edit, :update, :make_admin, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :index
  before_action :superadmin_user, only: [:make_admin, :destroy]
    
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    if signed_in?
      @voted_items = Post.evaluated_by(:post_votes, current_user)
    end
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:p], :per_page => 5)    
    @comments = @user.comments.paginate(page: params[:c], :per_page => 5)    
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to DailyDocket!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def make_admin 
    @user = User.find(params[:id])
    @user.toggle!(:admin)
    if @user.admin?
      flash[:success] = "User is now an Admin."
    else
      flash[:warning] = "User is no longer an Admin."
    end
    redirect_to @user
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:username, :name, :email, :password,
                                     :password_confirmation, :image, :remote_image_url)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
