# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  headline   :string(255)
#  url        :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  image      :string(255)
#

class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :url, presence: true, :url => true
  validates :headline, presence: true
  
  acts_as_taggable
  
  mount_uploader :image, ImageUploader
  
  has_reputation :post_votes, 
    :source => :user,
    :source_of => { :reputation => :posting_skill, :of => :user }
    
  def self.popular
    reorder('post_votes desc').find_with_reputation(:post_votes, :all)
  end  
  
  def domain
    if self.url.blank?
      nil
    else
      pu = URI.parse(self.url)
      pu.host.gsub(/^www\d*\./, "")
    end
  end
end
