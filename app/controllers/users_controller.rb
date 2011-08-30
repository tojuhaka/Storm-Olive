class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.nick
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome!"
      sign_in @user
      redirect_to user_path(@user)
    else 
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Muokkaa"
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end
end
