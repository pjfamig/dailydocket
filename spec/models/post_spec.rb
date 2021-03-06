require 'spec_helper'

describe Post do

  let(:user) { FactoryGirl.create(:user) }
  before { @post = user.posts.build(headline: "Lorem ipsum", url: "http://paulfamiglietti.com") }

  subject { @post }

  it { should respond_to(:headline) }
  it { should respond_to(:url) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:comments) }
  it { should respond_to(:image) }
  it { should respond_to(:active) }
  it { should_not be_active }
  
  
  its(:user) { should eq user }
  
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @post.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank headline" do
    before { @post.headline = " " }
    it { should_not be_valid }
  end
  
  describe "with blank url" do
    before { @post.url = " " }
    it { should_not be_valid }
  end
  
  describe "with active attribute set to 'true'" do
    before do
      @post.save!
      @post.toggle!(:active)
    end

    it { should be_active }
  end
end