class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :url, presence: true
  validates :headline, presence: true
  acts_as_taggable
end
