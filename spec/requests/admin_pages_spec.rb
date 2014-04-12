require 'spec_helper'

describe 'Admin pages' do
  subject { page }
  
  describe "index" do
    let(:admin) { FactoryGirl.create(:admin) }
    let!(:post1) { FactoryGirl.create(:post, user: admin) }
    let!(:post2) { FactoryGirl.create(:post, user: admin) }
  
    before do
      sign_in admin
      visit admin_index_path
    end
      
    it { should have_content('New Post') }
    it { should have_content('Active Posts') }
    it { should have_content('Pending Posts') }
    it { should have_content('Recent Comments') }
    it { should have_title('Admin Section') }
    
    # describe "recent posts" do
    #   it { should have_content(post1.headline) }
    #   it { should have_content(post2.headline) }
    # end
  end
  
  
end