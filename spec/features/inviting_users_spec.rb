require 'spec_helper'

feature 'Inviting users' do
  scenario 'an admin invites a attendant' do
    new_user_email = 'new@mail.com'
    user_type = 'attendant'
    admin = create(:admin)
    sign_in(admin)

    visit new_invitation_path
    find('#invitation_email').set(new_user_email)
    click_button I18n.t('helpers.submit.invitation.create')

    expect(Invitation.first.user.email).to eq new_user_email
    expect(Invitation.first.user.user_type).to eq user_type
    expect(Invitation.first.sender.email).to eq admin.email
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(ActionMailer::Base.deliveries.first.body).to include I18n.t('mailer.invitations.body')
    expect(ActionMailer::Base.deliveries.first.subject).to include I18n.t('mailer.invitations.subject')
  end

  scenario 'a client invites another client' do
    new_user = 'john@example.org'
    current_user = create(:client, :related_with_groups, groups_count: 1)
    group_id = current_user.group_id
    user_type = 'client'
    sign_in(current_user)

    visit new_invitation_path
    find('#invitation_email').set new_user
    click_button I18n.t('helpers.submit.invitation.create')

    expect(Invitation.first.user.email).to eq new_user
    expect(Invitation.first.user.group_id).to eq group_id
    expect(Invitation.first.user.user_type).to eq user_type
    expect(Invitation.first.sender.email).to eq current_user.email
    expect(ActionMailer::Base.deliveries.size).to eq 1
  end

  scenario 'a client invites an en existing user' do
    client        = create(:user, :related_with_groups)
    existent_user = create(:user)
    sign_in(client)

    visit new_invitation_path
    find('#invitation_email').set existent_user.email
    click_button I18n.t('helpers.submit.invitation.create')

    expect(page).to have_content(I18n.t('invitation.flash_messages.invited_user', email: existent_user.email))
  end
end
