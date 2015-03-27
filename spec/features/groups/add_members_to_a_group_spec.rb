require 'spec_helper'

feature 'Adding members to a group' do
  scenario 'an admin adds a member to a group, the member should appear as pending', js: true do
    email = 'jane@doe.org'
    admin = create(:admin)
    group = create(:group)
    sign_in admin

    visit_group(group.name)
    add_new_member(email)

    expect(group.members.pending.map(&:email)).to eq([email])
  end

  def visit_group(group_name)
    click_link group_name
  end

  def add_new_member(email)
    find('a.add-user').click
    page.evaluate_script(%Q($('#member_id').val('#{email}')))
    click_button I18n.t('group.links.add_member')
  end
end
