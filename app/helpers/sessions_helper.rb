module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def admin_user
    unless current_user.admin
      flash[:danger] = "You do not have permission."
      redirect_to(root_url)
    end
  end
  
  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def signed_in_user
    unless signed_in?
      respond_to do |format|
        format.html {
          store_location
          flash[:warning] = "Please sign in."
          redirect_to signin_url } 
        format.js {
          flash[:warning] = "Please sign in."
          flash.keep(:warning)
          render js: "window.location.pathname = #{signin_path.to_json}"
        }
      end
    end
  end
  
  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
    # session.delete(:return_to)
  end

  private 
  
    def store_location
      session[:return_to] = request.url if request.get?
    end
    
    def clear_return_to
      session[:return_to] = nil
    end
  
end
