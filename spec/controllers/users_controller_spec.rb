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

    it "should have a name field" do
      get :new
      response.should have_selector("input[type='text'] [name='user[name]']")
    end

    it "should have a email field" do
      get :new
      response.should have_selector("input[type='text'] [name='user[email]']")
    end

    it "should have a password field" do
      get :new
      response.should have_selector("input[type='password'] [name='user[password]']")
    end

    it "should have a password_confirmation field" do
      get :new
      response.should have_selector("input[type='password'] [name='user[password_confirmation]']")
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

  describe "POST 'create" do

    describe "failure" do

      before(:each) do 
        @attr = { name: "", email: "", password: "", password_confirmation: ""}
      end

      it "should not accept user without data" do
        lambda do
          post :create, user: @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, user: @attr
        response.should have_selector("title", content: "Sign Up!")
      end

      it "should render the new page" do
        post :create, user: @attr
        response.should render_template('new')
      end


    end

    describe "success" do

      before(:each) do
        @attr = {name: "Exmpl", email: "ex@mp.le", password: "1234567", password_confirmation: "1234567"}
      end

      it "should create user whith params" do
        lambda do
          post :create, user: @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user page" do
        post :create, user: @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should show a welcome message" do
        post :create, user: @attr
        flash[:success].should =~ /welcome to samole/i
      end

    end

  end

end
