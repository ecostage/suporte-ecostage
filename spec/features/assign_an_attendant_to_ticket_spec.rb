require 'spec_helper'

feature 'assign an attendant to a ticket' do
  scenario 'an attendant assigns another attendant', js: true do
    attendant = create(:attendant)
    channel = create(:channel)
    ticket = create(:ticket, channel: channel)
    sign_in(attendant)
    visit channel_ticket_path(channel, ticket)

    assign_attendant_to_ticket(attendant)

    expect(page).to have_content ticket.reload.assign_to.email
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end

  def assign_attendant_to_ticket(attendant)
    find('#assign-to-target').click
    find('#attendant_id').select(attendant.email)
    click_button I18n.t('links.save')
  end
end
