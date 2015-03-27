require 'spec_helper'

feature 'client can not visit tickets' do
  scenario 'when a ticket belongs to a channel which he does not have access' do
    client = create(:client)
    ticket = create(:ticket)
    channel_without_ticket = create(:channel)
    create(:channel, tickets: [ticket])
    create(:group, channels: [channel_without_ticket], members: [client])
    sign_in(client)

    visit channel_ticket_path(channel_without_ticket, ticket)

    expect(page.current_path).to eq authenticated_user_root_path
  end
end
