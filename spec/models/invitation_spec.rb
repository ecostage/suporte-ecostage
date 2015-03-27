require 'spec_helper'

describe Invitation do
  describe '#send_email' do
    it 'sends an invitation mail' do
      invitation_mailer = double
      invitation = Invitation.new

      expect(InvitationMailer).to receive(:invite).and_return(invitation_mailer)
      expect(invitation_mailer).to receive(:deliver)
      invitation.send_email
    end
  end

  describe '#token' do
    it 'generates its token' do
      invitation = create(:invitation)

      expect(invitation.token).not_to be_nil
    end
  end
end
