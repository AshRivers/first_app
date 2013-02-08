require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do

    describe "when not signed_in" do

      it "should be successful" do
        get 'home'
        response.should be_success
      end

      it "should have right title" do
        get 'home'
        response.should have_selector("title", content: "| Home!")
      end
    end
    
    describe "when signed_in" do
      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        other_user = FactoryGirl.create(:user, email: FactoryGirl.generate(:email))
        other_user.follow!(@user)
      end

      it "should have the right following/followers counter" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
    end

    it "should paginate users" do
      @user = test_sign_in(FactoryGirl.create(:user))
      50.times do 
        FactoryGirl.create(:micropost, :user => @user, content: "some")
      end
      get 'home'
      response.should have_selector("div.pagination")
      response.should have_selector("a", href: "/pages/home?page=2", content: "2")
      response.should have_selector("a", href: "/pages/home?page=2", content: "Next")
    end

  end

  describe "GET 'contact'" do

    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have right title" do
      get 'contact'
      response.should have_selector("title", content: "| Contact!")
    end

  end

  describe "GET 'about'" do

    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have right title" do
      get 'about'
      response.should have_selector("title", content: "| About!")
    end

  end

  describe "GET 'help'" do

    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have right title" do
      get 'help'
      response.should have_selector("title", content: "| Help!")
    end

  end

end
