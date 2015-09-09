class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user     # equivalent redirect_to user_url(@user)
      flash[:success] = "Welcome to the Sample App!"

    else
      render 'new'
    end
  end

  private
  # strong param
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
