class CommentNotificationMailer < ActionMailer::Base
  default from: 'Suporte! <contato@tracersoft.com.br>'
  layout 'notification'

  def notify(emails, comment)
    @comment = comment
    mail to: emails, subject: "Novo comentário no ticket #{@comment.ticket.subject}"
  end
end
