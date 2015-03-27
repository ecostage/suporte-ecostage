require 'spec_helper'

feature 'Group' do
  scenario 'An admin creates a group', js: true do
    admin = create(:admin)
    sign_in(admin)

    find('a#create-group').click
    fill_in I18n.t('activerecord.attributes.group.name'), with: 'GVces'
    fill_in I18n.t('activerecord.attributes.group.purpose'), with: 'testando'
    click_button I18n.t('links.save')

    expect(Group.all.map(&:name)).to eq ['GVces']
  end

  scenario 'Attendant add a channel to a group', js: true do
    group = create(:group)
    channel = create(:channel)
    attendant = create(:attendant)
    sign_in(attendant)

    visit group_path(group)
    find('#add-channel').click
    find('#_channel_id').select(channel.name)
    click_button I18n.t('group.links.add_channel')

    expect(group.reload.channels.map(&:name)).to eq [channel.name]
  end
end
