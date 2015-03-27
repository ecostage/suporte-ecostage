require "rails_helper"

RSpec.describe NotificationMailer, :type => :mailer do
  describe 'deliver' do
    let(:channel) { create(:channel) }
    let(:client) { create(:client) }
    let(:ticket) { create(:ticket, status: :done , channel: channel, created_by: client) }
    let(:notification) { create(:notification, created_by: client, notifiable: ticket, action: :done) }
    let(:mail) { NotificationMailer.instructions(notification) }

    it 'renders the subject' do
      expect(mail.subject).to eq(notification.subject)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(notification.recipients.map(&:email))
    end

    it 'has the email of who triggered the notification' do
      expect(mail.body.parts.first.body.raw_source).to match(notification.created_by.email)
    end
  end
end
