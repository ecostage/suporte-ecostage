require 'spec_helper'

feature 'an attendant cancels a ticket' do
  scenario 'the user should see the reason' do
    cancel_reason = 'It is not a bug!'
    ticket = create(:ticket, status: :canceled, cancel_reason: cancel_reason)
    channel = create(:channel, tickets: [ticket])
    group = create(:group, channels: [channel])
    client = create(:client, group: group)
    sign_in client

    visit channel_ticket_path(channel, ticket)

    expect(page).to have_css(".stamp[title='#{cancel_reason}']")
  end
end
