class UserMailer < ActionMailer::Base
  default from: "info@dailydocket.org"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "DailyDocket: Password Reset"
  end
  
  # => method for post activated
  
  # => method for notification
  
end
