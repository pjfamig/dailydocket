# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  post_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  ancestry   :string(255)
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true, length: { maximum: 8000 }

  has_ancestry 
  
  has_reputation :comment_votes, 
    :source => :user,
    :source_of => { :reputation => :commenting_skill, :of => :user }
  
end
