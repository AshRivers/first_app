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

    it "should have users microposts" do
      @mp1 = FactoryGirl.create(:micropost, content: "asd", user: @user, created_at: 1.day.ago)
      @mp2 = FactoryGirl.create(:micropost, content: "dsa", user: @user, created_at: 1.hour.ago)
      get :show, id: @user
      response.should have_selector("span.content", content: @mp1.content)
      response.should have_selector("span.content", content: @mp2.content)
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

  describe "GET 'edit'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should be succesfull" do
      get :edit, id: @user
      response.should be_success
    end

    it "should render the right title" do
      get :edit, id: @user
      response.should have_selector("title", content: "Edit User")
    end

    it "should have a link to change gravatar" do
      get :edit, id: @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", href: gravatar_url,
                                         content: "change")
    end

  end

  describe "PUT 'update'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should render the edit page" do
        put :update, id: @user, user: @attr
        response.should render_template("edit")
      end

      it "should have the right title" do
        put :update, id: @user, user: @attr
        response.should have_selector("title", content: "Edit")
      end

    end

    describe "success" do

      before(:each) do
        @attr = { name: "ASDFG", email: "qw@as.rt", password: "7654321", password_confirmation: "7654321"}
      end

      it "should update user" do
        put :update, id: @user, user: @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect_to user show page" do
        put :update, id: @user, user: @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have the flash message" do
        put :update, id: @user, user: @attr
        flash[:success].should =~ /updated/i
      end

    end

  end

  describe "authentication of edit/update pages" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, id: @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, id: @user, user: {}
        response.should redirect_to(signin_path)
      end

    end

    describe "for signed-in users" do

      before(:each) do
        wrong_user = FactoryGirl.create(:user, email: "some@cc.vv")
        test_sign_in(wrong_user)
      end

      it "should require matching users for edit" do
        get :edit, id: @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for update" do
        put :update, id: @user, user: {}
        response.should redirect_to(root_path)
      end

    end

  end

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in user" do

      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        second = FactoryGirl.create(:user, name: "Bob", email: "another@example.com")
        third  = FactoryGirl.create(:user, name: "Ben", email: "another@example.net")

        @users = [@user, second, third]

        30.times do
          @users << FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
        end
      end

      it "should be successful" do
        get "index"
        response.should be_success
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should_not have 'delete' links" do
        get :index
        response.should_not have_selector("input", value: "delete")
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("a", href: "/users?page=2", content: "2")
        response.should have_selector("a", href: "/users?page=2", content: "Next")
      end
    end

    describe "for admin" do
      before(:each) do
        admin = FactoryGirl.create(:user, email: "dmn@ex.le", admin: true)
        test_sign_in(admin)
      end

      it "should have buttons to delete" do
        get :index
        response.should have_selector("input", value: "delete")
      end
    end

  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, id: @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do

      it "should protect page" do
        test_sign_in(@user)
        delete :destroy, id: @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = FactoryGirl.create(:user, email: "admin@ex.le", admin: true)
        test_sign_in(@admin)
      end

      it "should destroy a user" do
        lambda do
          delete :destroy, id: @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, id: @user
        response.should redirect_to(users_path)
      end

      it "should not delete an admin user" do
        lambda do
          delete :destroy, id: @admin
        end.should_not change(User, :count)
      end

    end

  end
  
end

