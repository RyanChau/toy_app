class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # remember user
      redirect_to user    # Rails automatically converts this to the route for the user’s profile page: user_url(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      # Unlike the contents of flash, the contents of flash.now disappear as soon as we go to another page
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?   # avoid problems when logging in two windows (of the same browser) and one of them logging out
    redirect_to root_url
  end
end
