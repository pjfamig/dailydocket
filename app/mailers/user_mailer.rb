class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "DailyDocket: Reset your password"
  end
  
  # => method for post activated
  
  # => method for notification
end
