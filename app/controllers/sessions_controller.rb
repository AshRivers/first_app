class SessionsController < ApplicationController
  def new
  	@title = "Sign In!"
  end

  def create
  	user = User.authentificate(params[:session][:email],
                           	params[:session][:password])
  	if user.nil?
  		flash.now[:error] = "Invalid email/pass combination"
  		@title = "Sign In!"
  		render 'new'
  	else
  		sign_in user
  		redirect_to user
  	end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
