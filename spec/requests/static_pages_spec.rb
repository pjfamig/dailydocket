require 'spec_helper'

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }
    
    it { should have_content('DailyDocket') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
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