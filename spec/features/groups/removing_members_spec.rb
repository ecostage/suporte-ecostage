require 'spec_helper'

feature 'Removing members from a group' do
  scenario 'an admin removes a member, the member is marked as inactive', js: true do
    admin = create(:admin)
    members = create_list(:client, 3)
    group = create(:group, members: members)
    sign_in admin

    remove_member_from_a_group(members.first, group)

    expect(group.reload.members.inactive.first.email).to eq members.first.email
  end

  def remove_member_from_a_group(member, group)
    click_link group.name
    find(:xpath, %Q(//a[@href='#{inactivate_member_group_path(group, member_id: member.id)}'])).click
  end
end
