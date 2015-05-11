require 'spec_helper'

feature 'commenting a ticket' do
  given!(:content) { 'Some content' }
  given!(:attendant) { create(:attendant) }
  given!(:channel) { create(:channel) }
  given!(:group) { create(:group, channels: [channel]) }
  given!(:ticket) { create(:ticket, channel: channel) }
  given!(:client) { create(:client, group: group) }
  given(:file) { Rails.root.join('spec/support/files/tracer.png') }

  background do
    sign_in(client)

    visit channel_ticket_path(ticket.channel, ticket)
  end

  scenario 'when a client make a comment' do
    find('#ticket_comments_attributes_0_content').set(content)
    click_button I18n.t('comment.new.button')

    expect(ticket.comments.map(&:content)).to eq([content])
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end

  scenario 'when a client wants to add a file' do
    attach_file('ticket[comments_attributes][0][attachment]', file)
    click_button I18n.t('comment.new.button')
    expect(page).to have_content('tracer.png')
  end
end
