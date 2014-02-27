require 'spec_helper'

describe "Static pages" do

  describe "Home page" do
    it "should have the content 'DailyDocket'" do
      visit '/static_pages/home'
      expect(page).to have_content('DailyDocket')
    end
    it "should have the title 'Home'" do
      visit '/static_pages/home'
      expect(page).to have_title("DailyDocket | Home")
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