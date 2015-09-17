class CommentsController < ApplicationController

  def create
    temp = current_user.post_comment(params[:comment][:content], params[:comment][:micropost_id])

    # @micropost = Micropost.find(params[:comment][:micropost_id])
    # if(@micropost)
    #   @comment = @micropost.comments.build(content: comment_params, commenter_id: current_user.id)
      if temp
        flash[:success] = "Comment created!"
        redirect_to(:back)
        # redirect_to root_url
      else
        flash[:error] = "Comment wrong!"
        render 'static_pages/home'
        # redirect_to(:back)
      end
    # end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
