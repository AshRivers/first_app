# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
  	@attr = { 	name: "A Nother",
  				email: "some@ema.il",
  				password: "hard_pass",
  				password_confirmation: "hard_pass"
  			}
  end

  it "should create user giver right params" do
  	User.create!(@attr)
  end

  it "should require a name" do
  	no_name_user = User.new(@attr.merge(name: ""))
  	no_name_user.should_not be_valid
  end

  it "should require an email" do
  	no_name_user = User.new(@attr.merge(email: ""))
  	no_name_user.should_not be_valid
  end

  it "should not accept names longer than 50" do
  	long_name = "a"*51
  	long_name_user = User.new(@attr.merge(name: long_name))
  	long_name_user.should_not be_valid
  end

  it "shout accept valid emails" do
  	valid_emails = %w[user@exm.ru FOO@BA.R sdf@asd.asd.asd ]
  	valid_emails.each do |em|
  		user_with_valid_email = User.new(@attr.merge(email: em))
  		user_with_valid_email.should be_valid
  	end
  end

  it "should_not accept invalid emails" do
  	invalid_emails = %w[user@.ru FOOA.R sdf@asd. ]
  	invalid_emails.each do |em|
  		user_with_valid_email = User.new(@attr.merge(email: em))
  		user_with_valid_email.should_not be_valid
  	end
  end

  it "should have unique email" do
  	User.create!(@attr)
  	user_with_same_email = User.new(@attr)
  	user_with_same_email.should_not be_valid
  end

  it "should reject same uppercase emails" do
  	uppercase_email = @attr[:email].upcase
  	User.create!(@attr.merge(email: uppercase_email))
  	user_with_same_email = User.new(@attr)
  	user_with_same_email.should_not be_valid
  end

  it "should require password" do
  	User.new(@attr.merge(password: "", password_confirmation: "")).should_not be_valid
  end

  it "should require matching password_confirmation" do
  	User.new(@attr.merge(password_confirmation: "asd")).should_not be_valid
  end

  it "should reject short password" do
  	short_pass = "a"*5
  	short_user = @attr.merge(password: short_pass, password_confirmation: short_pass)
  	User.new(short_user).should_not be_valid
  end

  it "should reject long password" do
  	long_pass = "a"*24
  	long_user = @attr.merge(password: long_pass, password_confirmation: long_pass)
  	User.new(long_user).should_not be_valid
  end

  describe "password encryption" do

  	before(:each) do
  		@user = User.create!(@attr)
  	end

  	it "should have an encrypted pass attr" do
  		@user.should respond_to(:encrypted_password)
  	end

  	it "should not be blank" do
  		@user.encrypted_password.should_not be_blank
  	end

      describe "has password? method" do

        it "should be true if pass match" do
          @user.has_password?(@attr[:password]).should be_true
        end

        it "should be false if pass don't match" do
          @user.has_password?("invalid_pass").should be_false
        end

      end

      describe "authentificate method" do

        it "should return nil in email/pass mismatch" do
          wrong_user = User.authentificate(@attr[:email], "wrong_user")
          wrong_user.should be_nil
        end

        it "should return nil if email doesnt exist" do
          wrong_user = User.authentificate("wr@ong.us",@attr[:password])
          wrong_user.should be_nil
        end

        it "should return user if everythig cool" do
          right_user = User.authentificate(@attr[:email],@attr[:password])
          right_user.should == @user
        end

      end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "microposts associations" do

    before(:each) do
      @user = User.create(@attr)
      @mp1 = FactoryGirl.create(:micropost, content: "asd", user: @user, created_at: 1.day.ago)
      @mp2 = FactoryGirl.create(:micropost, content: "dsa", user: @user, created_at: 1.hour.ago)
    end

    it "should have a micropost attr" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts order" do
      @user.microposts.should == [@mp2,@mp1]
    end

    it "should destroy dependent microposts" do
      @user.destroy
      [@mp1,@mp2].each do |mp|
        Micropost.find_by_id(mp.id).should be_nil
      end
    end

    describe "feed" do
      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should have user microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include a different user's microposts" do
        mp3 = FactoryGirl.create(:micropost,
                      user: FactoryGirl.create(:user, 
                        :email => FactoryGirl.generate(:email)), content: "qw")
        @user.feed.include?(mp3).should be_false
      end
    end

  end
	
end

