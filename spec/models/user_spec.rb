require 'spec_helper'

describe User do

  before { @user = User.new(username: "user1", name: "Example User", email: "user@example.com", 
                            password: "foobar", password_confirmation: "foobar") }
                            
  before { @user2 = User.new(username: "pjfamig", name: "Second Example User", email: "user2@example.com",
                            password: "foobar", password_confirmation: "foobar") }                          

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  # it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:superadmin) }
  it { should respond_to(:posts) }
  it { should respond_to(:feed) }
  it { should respond_to(:comments) }
  it { should respond_to(:image) }
  it { should respond_to(:username) }
  
  it { should be_valid }
  it { should_not be_admin }
  it { should_not be_superadmin }
  
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "with SUPERadmin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:superadmin)
    end

    it { should be_superadmin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                       foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  
  describe "when username is already taken" do
    before do
      user_with_same_username = @user2.dup
      user_with_same_username.username = @user2.username.upcase
      user_with_same_username.save
    end
    it "should be invalid" do
      expect(@user2).not_to be_valid
    end
  end

  describe "when name is too long" do
    before { @user.username = "a" * 21 }
    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  # describe "when password doesn't match confirmation" do
  #  before { @user.password_confirmation = "mismatch" }
  #  it { should_not be_valid }
  # end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) } 
    
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end  
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "post associations" do

    before { @user.save }
    let!(:older_post) do
      FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_post) do
      FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago)
    end

    describe "status" do
      its(:feed) { should include(newer_post) }
      its(:feed) { should include(older_post) }
    end

    it "should have the right posts in the right order" do
      expect(@user.posts.to_a).to eq [newer_post, older_post]
    end
    
    it "should destroy associated posts" do
      posts = @user.posts.to_a
      @user.destroy
      expect(posts).not_to be_empty
      posts.each do |post|
        expect(Post.where(id: post.id)).to be_empty
      end
    end
  end
  
  describe "comment associations" do

    before { @user.save }
            
    let!(:older_comment) do
      FactoryGirl.create(:comment, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_comment) do
      FactoryGirl.create(:comment, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right comments in the right order" do
      expect(@user.comments.to_a).to eq [newer_comment, older_comment]
    end
  
    
    it "should destroy associated comments" do
      comments = @user.comments.to_a
      @user.destroy
      expect(comments).not_to be_empty
      comments.each do |comment|
        expect(Comment.where(id: comment.id)).to be_empty
      end
    end
    
  end
  
end