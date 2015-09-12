class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
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
