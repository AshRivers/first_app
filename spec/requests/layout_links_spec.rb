require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do
    #it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
     # get layout_links_index_path
      #response.status.should be(200)
    #end

    it "should have home at / " do
    	get '/'
    	response.should have_selector('title', content: "Home!")
    end

    it "should have contact at /contact " do
    	get '/contact'
    	response.should have_selector('title', content: "Contact!")
    end

    it "should have about at /about " do
    	get '/about'
    	response.should have_selector('title', content: "About!")
    end

    it "should have help at /help " do
    	get '/help'
    	response.should have_selector('title', content: "Help!")
    end

    it "should have sign up at /singup " do
    	get '/signup'
    	response.should have_selector('title', content: "Sign Up!")
    end

    it "is alternative checking " do
    	visit root_path
		click_link "About"
    	response.should have_selector('title', content: "About!")
		click_link "Help"
    	response.should have_selector('title', content: "Help!")
		click_link "Contact"
    	response.should have_selector('title', content: "Contact!")
		click_link "Home"
    	response.should have_selector('title', content: "Home!")
    	click_link "Signup Now!"
    	response.should have_selector('title', content: "Sign Up!")
    end

  end

  describe "when not signed in" do

    it "should have a 'sign in' link" do
        visit root_path
        response.should have_selector('a', href: signin_path, content: "Sign In")
    end
  end

  describe "when sign in" do

    before(:each) do
        @user = FactoryGirl.create(:user)
        visit signin_path
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password
        click_button
    end

    it "should have the 'sign out' link " do
        visit root_path
        response.should have_selector('a', href: signout_path, content: "Sign Out")
    end

    it "should have a profile link" do
        visit root_path
        response.should have_selector('a', href: user_path(@user), content: "Profile")
    end

    end
end
