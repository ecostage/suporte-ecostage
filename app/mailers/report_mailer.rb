class ReportMailer < ActionMailer::Base
  layout 'layouts/notification'
  default from: 'Suporte! <contato@tracersoft.com.br>'

  def weekend_report(date = Date.today)
    @report = WeekendReport.new(date)
    recipients = User.admin.active
    mail to: recipients, subject: I18n.t('mailer.reports.subject')
  end
end
