class CommentPolicy < Struct.new(:user, :comment)
  def download?
    !user.client? or ticket.created_by == user or user.group.channels.include? ticket.channel
  end

  private

  def ticket
    @ticket ||= comment.ticket
  end
end
