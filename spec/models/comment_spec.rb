require 'spec_helper'

describe Comment do

  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post) }

  before { @comment = user.comments.build(content: "Lorem ipsum", post_id: post.id) }


  subject { @comment }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:post_id) }
  
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @comment.user_id = nil }
    it { should_not be_valid }
  end

  describe "when post_id is not present" do
    before { @comment.post_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank content" do
    before { @comment.content = " " }
    it { should_not be_valid }
  end
  
  describe "with content that is too long" do
    before { @comment.content = "a" * 8001 }
    it { should_not be_valid }
  end
  
end