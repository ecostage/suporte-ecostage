require 'spec_helper'

feature 'clients can not see comment form' do
  scenario 'when the status is approved' do
    ticket = create(:ticket, status: :approved)
    channel = create(:channel, tickets: [ticket])
    group = create(:group, channels: [channel])
    client = create(:client, group: group)
    sign_in client

    visit channel_ticket_path(channel, ticket)

    expect(page).not_to have_css("#edit_ticket_#{ticket.id}")
  end

  scenario 'when the status is canceled' do
    ticket = create(:ticket, status: :canceled)
    channel = create(:channel, tickets: [ticket])
    group = create(:group, channels: [channel])
    client = create(:client, group: group)
    sign_in client

    visit channel_ticket_path(channel, ticket)

    expect(page).not_to have_css("#edit_ticket_#{ticket.id}")
  end
end
