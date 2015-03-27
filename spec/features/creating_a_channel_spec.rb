require 'spec_helper'

feature 'creating a channel' do
  scenario 'admin creates a channel with success', js: true do
    channel_name = 'Name of the channel'
    channel_purpose = 'Purpose of the channel'
    admin = create(:admin)
    sign_in(admin)

    create_new_channel(channel_name, channel_purpose)

    expect(page).to have_content channel_name
  end

  def create_new_channel(channel_name, channel_purpose)
    find('a#create-channel').click
    fill_in I18n.t('activerecord.attributes.channel.name'), with: channel_name
    fill_in I18n.t('activerecord.attributes.channel.purpose'), with: channel_purpose
    click_button I18n.t('links.save')
  end
end
