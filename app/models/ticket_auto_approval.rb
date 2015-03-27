class TicketAutoApproval
  def initialize(ticket)
    @ticket = ticket 
  end

  def auto_approve!
    if @ticket.old? && @ticket.done?
      @ticket.approved!
      create_comment
    end
  end

  private
  def create_comment
    Comment.create(
      ticket: @ticket, 
      author: Robot.retrieve, 
      content: I18n.t('auto_approval_comment')
    )
  end
end
