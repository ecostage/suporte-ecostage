class NotificationMailer < ActionMailer::Base
  default from: "Suporte! <contato@tracersoft.com.br>"
  layout 'notification'

  def instructions(notification)
    @recipients = notification.recipients
    @template = notification.template
    @subject = notification.subject
    @notifiable = notification.notifiable
    @notification = notification
    @actor = notification.created_by
    attachments.inline["#{@notifiable.status}.png"] = File.read("public/images/stamps/#{@notifiable.status}.png") unless @notifiable.unread?
    attachments.inline["missing.jpg"] = File.read("public/images/avatars/square/missing.jpg") unless @actor.avatar.present?

    mail to: @recipients.map(&:as_recipient), subject: @subject do |format|
      format.html { render @template }
    end
  end
end
