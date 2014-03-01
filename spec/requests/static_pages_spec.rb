require 'spec_helper'

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }
    
    it { should have_content('DailyDocket') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:post, user: user, headline: "Lorem ipsum", url: "http://paulfamiglietti.com")
        FactoryGirl.create(:post, user: user, headline: "Dolor sit amet", url: "http://paulfamiglietti.com")
        sign_in user
        visit root_path
      end
    
      it "should render the news feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.headline)
        end
      end
    end
  end
  
  describe "About page" do
    before { visit about_path }
    
    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end
    
  describe "Rules page" do
    before { visit rules_path }
    
    it { should have_content('Rules') }
    it { should have_title(full_title('Rules')) }
  end    
  
end