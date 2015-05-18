class MailPreview < MailView
  def weekend_summary
    ReportMailer.weekend_report(Ticket.first.created_at)
  end
end
