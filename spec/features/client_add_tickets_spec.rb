require 'spec_helper'

feature 'clients add tickets' do
  scenario 'client adds new ticket' do
    ticket_subject = 'Subject'
    ticket_content = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
    client = create(:client, :related_with_groups)
    channel = client.group.channels.first
    channel_without_tickets = client.group.channels.last
    sign_in(client)

    find(".channel", match: :first).click
    click_link I18n.t('links.ticket.new')
    create_new_ticket(ticket_subject, ticket_content)

    expect(page.current_path).to eq channel_ticket_path(channel, channel.tickets.first)
    expect(channel.tickets.map(&:subject)).to eq([ticket_subject])
    expect(channel_without_tickets.tickets).to be_empty
    expect(page).to have_content(client.email)
  end

  def create_new_ticket(ticket_subject, ticket_content)
    find('#ticket_subject').set(ticket_subject)
    find('#ticket_content').set(ticket_content)
    find('#ticket_is_priority').set(true)
    click_button I18n.t('links.ticket.save')
  end
end
