class CommentsController < ApplicationController
  def download
    comment = Comment.find(params[:id])
    authorize comment, :download?
    redirect_to comment.attachment.expiring_url(10)
  end
end
