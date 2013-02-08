require 'spec_helper'

describe Micropost do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = { :content => "value for content" }
  end

  it "should create a new instance given valid attributes" do
    @user.microposts.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end

  describe "validations" do
    it "should require a user_id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.microposts.build(content: "").should_not be_valid
    end

    it "should reject long content" do
      @user.microposts.build(content: "a"*100).should_not be_valid
    end
  end

  describe "from_users_followed_by" do
    
    before(:each) do
      @second_user = FactoryGirl.create(:user, email: FactoryGirl.generate(:email))
      @other_user = FactoryGirl.create(:user, email: FactoryGirl.generate(:email))

      @user_post = @user.microposts.create!(content: "user")
      @second_user_post = @second_user.microposts.create!(content: "second_user")
      @other_user_post = @other_user.microposts.create!(content: "other_user")
      @user.follow!(@second_user)
    end
 
    it "should have this class method" do
      Micropost.should respond_to(:from_users_followed_by)
    end

    it "should include followed user's microposts" do
      Micropost.from_users_followed_by(@user).should include(@second_user_post)
    end

    it "should include user's own microposts" do
      Micropost.from_users_followed_by(@user).should include(@user_post)
    end

    it "should not include unfollowed users microposts" do
      Micropost.from_users_followed_by(@user).should_not include(@other_user_post)
    end
  end
end
