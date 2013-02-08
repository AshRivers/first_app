require 'spec_helper'

describe MicropostsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST create" do
    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:user))
    end

    describe "failure" do
      before(:each) do
        @attr = {content: ""}
      end

      it "should not create a micropost" do
        lambda do
          post :create, micropost: @attr
        end.should_not change(Micropost, :count)
      end

      it "should render the home page" do
        post :create, micropost: @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do
      before(:each) do
        @attr = {content: "Some"}
      end

      it "should create a micropost" do
        lambda do
          post :create, micropost: @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect_to home page" do
        post :create, micropost: @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /micropost created/i
      end
    end

  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = FactoryGirl.create(:user)
        wrong_user = FactoryGirl.create(:user, email: FactoryGirl.generate(:email))
        test_sign_in(wrong_user)
        @micropost = FactoryGirl.create(:micropost, :user => @user, content: "content")
      end

      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        @micropost = FactoryGirl.create(:micropost, :user => @user, content: "some")
      end

      it "should destroy the micropost" do
        lambda do
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end

      it "should_not destroy mp, created by another user" do
        wrong_user = FactoryGirl.create(:user, email: FactoryGirl.generate(:email))
        @mp2 = FactoryGirl.create(:micropost, user: wrong_user, content: "content")
        lambda do
          delete :destroy, id: @mp2
        end.should_not change(Micropost, :count)
      end
    end

  end

end