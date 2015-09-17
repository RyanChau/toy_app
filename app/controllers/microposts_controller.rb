class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def show
    @micropost = Micropost.find(params[:id])
    if(@micropost)
      @user = User.find(@micropost.user_id)
      @comments = Comment.where(micropost_id: params[:id])
      @comment = Comment.new
    else    # in case of the post is deleted
      redirect root_path
    end
# the micropost_id is automatically set by build
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
    # is just the previous URL
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

end