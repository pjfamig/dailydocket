require 'spec_helper'

describe "Static pages" do

  describe "Home page" do
    it "should have the content 'DailyDocket'" do
      visit '/static_pages/home'
      expect(page).to have_content('DailyDocket')
    end
    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title("DailyDocket")
    end

    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end
  end
  
  describe "About page" do
    it "should have the content 'About'" do
      visit '/static_pages/about'
      expect(page).to have_content('About')
    end
    it "should have the title 'About'" do
      visit '/static_pages/about'
      expect(page).to have_title("DailyDocket | About")
    end
  end
    
  describe "Rules page" do
    it "should have the content 'Rules'" do
      visit '/static_pages/rules'
      expect(page).to have_content('Rules')
    end
    it "should have the title 'Rules'" do
      visit '/static_pages/rules'
      expect(page).to have_title("DailyDocket | Rules")
    end
  end    
  
end