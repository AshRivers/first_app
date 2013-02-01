class UsersController < ApplicationController
  before_filter :authenticate, only: [:edit, :update, :index, :destroy]
  before_filter :right_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def new
    redirect_to root_path if signed_in?
  	@user = User.new
  	@title = 'Sign Up!'
  end

  def create 
    redirect_to root_path if signed_in?
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to Samole!"
      redirect_to @user
  	else
  		@title = 'Sign Up!'
  		render "new"
  	end
  end

  def index 
    @title = "All Users"
    @users = User.paginate(page: params[:page])
  end
  			
  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  	@title = @user.name
  end

  def edit
    @title = "Edit User"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    if User.find(params[:id]) == current_user
      redirect_to users_path 
      return
    end
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  private 

    def right_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
