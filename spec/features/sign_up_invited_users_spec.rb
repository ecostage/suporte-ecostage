require 'spec_helper'

feature 'sign up invited users' do
  scenario 'an invited user sign up' do
    client = create(:client, status: :pending)
    invited_user = create(:invitation, user: client)
    visit new_user_registration_path(invite_token: invited_user.token)

    find('#user_password').set 12345678
    find('#user_password_confirmation').set 12345678
    click_button  I18n.t('invitation.registration.button.submit')

    expect(page.current_path).to eq dashboard_path
    expect(client.reload.active?).to be true
  end
end
