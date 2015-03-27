require 'spec_helper'

feature 'Visiting dashboard' do
  scenario 'non user visits a dashboard' do
    visit dashboard_path

    expect(page.current_path).to eq new_user_session_path
  end

  scenario "when the user is admin" do
    user = create(:admin)
    channels = create_list(:channel, 2)
    sign_in(user)

    channels.each do |channel|
      expect(page).to have_content channel.name
    end
    expect(page.current_path).to eq authenticated_user_root_path
    expect(page).to have_link I18n.t('link.sign_out')
  end

  scenario "when the user is a client" do
    user = create(:client, :related_with_groups)
    sign_in(user)

    user.group.channels.each do |channel|
      expect(page).to have_content(channel.name)
    end
  end

  feature "Show tickets" do
    scenario "lastest tickets" do
      user = create(:admin)
      tickets = create_list(:ticket, 20)
      sign_in(user)
      visit dashboard_path
      tickets.each do |ticket|
        expect(page).to have_content(ticket.subject)
      end
    end
  end
end
