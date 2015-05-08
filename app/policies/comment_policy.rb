class CommentPolicy < Struct.new(:user, :comment)
  def show?
    !user.client? or ticket.created_by == user or user.group.channels.include? ticket.channel
  end

  def download?
    show?
  end

  private

  def ticket
    @ticket ||= comment.ticket
  end
end
