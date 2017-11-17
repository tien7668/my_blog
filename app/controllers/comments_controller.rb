class CommentsController < ApplicationController
  def save_comment
    if request.post?
      Comment.create(comment_params)
    else
      comment = Comment.find_by({id: comment_params["id"]})
      if comment.present?
        comment.update_attributes(comment_params)
      end
    end
  end

  private

  def comment_params
    params.require(:comment).merge({user_id: current_user.id}).permit(:id, :post_id, :content, :user_id)
  end
end
