require 'spec_helper'

feature 'commenting a ticket' do
  scenario 'when a client make a comment' do
    create(:attendant)
    content = 'Some content'
    channel = create(:channel)
    group = create(:group, channels: [channel])
    ticket = create(:ticket, channel: channel)
    client = create(:client, group: group)
    sign_in(client)

    visit channel_ticket_path(ticket.channel, ticket)
    find('#ticket_comments_attributes_0_content').set(content)
    click_button I18n.t('comment.new.button')

    expect(ticket.comments.map(&:content)).to eq([content])
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end
end
