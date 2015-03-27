class InvitationMailer < ActionMailer::Base
  layout 'layouts/notification'
  default from: 'Suporte! <contato@tracersoft.com.br>'

  def invite(invitation)
    @invitation = invitation
    mail(to: @invitation.user.email, subject: @invitation.subject)
  end
end
