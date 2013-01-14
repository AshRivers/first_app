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
  	@attr = {name: "A Nother", email: "some@ema.il"}
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


end
