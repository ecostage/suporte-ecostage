class ReportMailer < ActionMailer::Base
  layout 'layouts/notification'
  default from: 'Suporte! <contato@tracersoft.com.br>'

  def weekend_report(date = Date.today)
    @report = TicketsReport.new(date.all_week)
    recipients = User.attendant.active
    mail to: recipients, subject: I18n.t('mailer.reports.subject')
  end
end
