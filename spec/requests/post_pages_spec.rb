require 'spec_helper'

describe "Post pages" do

  subject { page }

  describe "post creation" do

    describe "as non-Admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }
      before { visit root_path }
      
      it { should_not have_content('Admin Panel') }
    end
    
    describe "as Admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin }
      before { visit root_path }

      describe "and invalid information" do
        it "should not create a post" do
          expect { click_button "Post" }.not_to change(Post, :count)
        end

        describe "error messages" do
          before { click_button "Post" }
          it { should have_content('error') }
        end
      end
      
      describe "and valid information" do
        before { fill_in 'post_headline', with: "Lorem ipsum" }
        before { fill_in 'post_url', with: "http://paulfamiglietti.com" }
        it "should create a post" do
          expect { click_button "Post" }.to change(Post, :count).by(1)
        end
      end
    
    end
  end
end