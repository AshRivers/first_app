require 'spec_helper'

describe UsersController do
	render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
    	get "new"
    	response.should have_selector('title', content: 'Sign Up!')
    end
  end

  describe "GET 'show'" do

    before(:each) do 
      @user = FactoryGirl.create(:user)
    end

    it "should be succesfull" do
      get :show, id: @user
      response.should be_success
    end

    it "should return the right user" do
      get :show, id: @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, id: @user
      response.should have_selector("title", content: @user.name)
    end

    it "should hane username in h1 tag" do
      get :show, id: @user
      response.should have_selector("h1", content: @user.name)
    end

    it "should hane user image in img tag" do
      get :show, id: @user
      response.should have_selector("img", class: "gravatar")
    end

  end

end