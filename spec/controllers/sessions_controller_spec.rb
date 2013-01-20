require 'spec_helper'

describe SessionsController do
	render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the rigth title" do
    	get :new
    	response.should have_selector("title", content: "Sign In!")
	  end
  
  end

  describe "POST 'create'" do
  	
  	describe "invalid email/password" do

  		before(:each) do
  			@attr = { email: "ex@pl.le", password: "long_pass"}
  		end

  		it "should re-render new page" do
  			post :create, session: @attr
  			response.should render_template("new")
  		end

  		it "should have a flash.now message" do
        	post :create, session: @attr
        	flash.now[:error].should =~ /invalid/i
    	end
	  end

	describe "valid email/pass" do
		before(:each) do
			@user = FactoryGirl.create(:user)
		 	#@user = User.create(name: "Michael",
      #                    email: "m@ic.re",
      #                    password: "qwertyuiop",
      #                    password_confirmation: "qwertyuiop")
      @atrr = { email: @user.email, password: @user.password}
		end

		it "should sign the user in" do
			lambda do
        post :create, session: @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end
		end

		it "should redirect to user page" do
      lambda do
			  post :create, session: @attr
			  response.should redirect_to(user_path(@user))
      end
		end
   end
  end

  describe "DELETE 'destroy'" do

    it "should sign a user out" do
      lambda do
      test_sign_in(FactoryGirl.create(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
      end
    end
  end

end
