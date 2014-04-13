# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  image                  :string(255)
#  superadmin             :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  username               :string(255)
#

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  has_reputation :karma,
    :source => [
      { :reputation => :posting_skill, :weight => 5 },
      { :reputation => :commenting_skill }]
      
  has_reputation :posting_skill,
      :source => { :reputation => :post_votes, :of => :posts }
  
  has_reputation :commenting_skill,
      :source => { :reputation => :comment_votes, :of => :comments }
          
  before_save { self.email = email.downcase }
  before_save { self.username = username.downcase }
  
  before_create :create_remember_token
  
  validates :name, length: { maximum: 50 }

  VALID_USERNAME_REGEX = /\A[A-Za-z0-9]+(?:[_-][A-Za-z0-9]+)*\z/

  validates :username, presence: true, 
                       length:        { in: 3..20 },
                       format:     { with: VALID_USERNAME_REGEX }, 
                       uniqueness:    { case_sensitive: false }
                        
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence:   true, 
                    format:     { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  
  # Custom validations to negate password_confirmation                  
  has_secure_password validations: false
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :password, presence: true, on: :create
  
  validates :password, length: { minimum: 6 }
  mount_uploader :image, ImageUploader
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def send_password_reset
    self.password_reset_token = User.new_remember_token
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Post.where("user_id = ?", id)
  end
  
  private
  
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
