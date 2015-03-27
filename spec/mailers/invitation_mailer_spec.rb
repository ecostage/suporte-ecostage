require 'spec_helper'

describe InvitationMailer do
  describe '.invite' do
    it 'sends the email' do
      invited_user = double('User', email: 'mail_to@teste.com')
      sender = double('Sender')
      invitation = double('Invitation', user: invited_user, token: 'invitation_token', sender: sender)
      allow(sender).to receive(:avatar)
      allow(sender).to receive(:email)
      allow(invitation).to receive(:subject)
      mailer = InvitationMailer.invite(invitation)

      expect(mailer.from).to eq ['contato@tracersoft.com.br']
      expect(mailer.to).to eq ['mail_to@teste.com']
      expect(mailer.body).to have_css(%(a[href="#{new_user_registration_url(invite_token: 'invitation_token')}"]))
    end
  end
end
