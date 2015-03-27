require 'spec_helper'

describe Notification do


  let!(:channel) { create(:channel) }
  let!(:ticket) { create(:ticket, channel: channel) }
  let!(:attendant) { create(:attendant) }
  let!(:client) { create(:client) }
  let!(:notification) { Notification.create(notifiable: ticket, created_by: client, action: :created) }

  it 'gets notifiable recipients' do
    recipients = notification.recipients
    expect(recipients.map(&:email)).to eq([attendant.email])
  end

  it 'tests full action_id' do
    expect(notification.action_id).to eq('notifications.ticket.created')
  end

  it 'tests namespace' do
    expect(notification.namespace).to eq('ticket')
  end

  it 'tests template' do
    expect(notification.template).to eq('notifications/ticket/created')
  end

  it 'translates the subject' do
    expect(notification.subject).to eq(I18n.translate(notification.action_id, notification.context))
  end

  it 'delivers a notification' do
    channel.members << attendant
    expect {
      notification.deliver
    }.to change(ActionMailer::Base.deliveries, :count).by(1)
  end
end
