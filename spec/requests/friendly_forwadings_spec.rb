require 'spec_helper'

describe "FriendlyForwadings" do
  
  it "should forward the requested page" do
  	user = FactoryGirl.create(:user)
  	visit edit_user_path(user)
  	fill_in :email, with: user.email
  	fill_in :password, with: user.password
  	click_button
  	response.should render_template('users/edit')
  end
end
