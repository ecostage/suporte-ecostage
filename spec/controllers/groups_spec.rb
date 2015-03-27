require 'spec_helper'

describe GroupsController do
  describe 'POST /groups/:id/inactive_member' do
    context 'a signed in user' do
      it 'sets it as inactive' do
        admin = create(:admin)
        member = create(:client)
        group = create(:group, members: [ member ])
        sign_in admin

        delete :inactivate_member, { id: group.id, member_id: member.id }, format: :json

        expect(group.reload.members.first.inactive?).to eq true
      end
    end

    context 'a unsigned in user' do
      it 'does not set as inactive' do
        member = create(:client)
        group = create(:group, members: [ member ])

        delete :inactivate_member, { id: group.id, member_id: member.id }, format: :json

        expect(group.reload.members.first.inactive?).to eq false
      end
    end
  end

  describe 'POST add_user' do
    context 'when an admin wants to add a new user' do
      it 'adds members to a group' do
        new_client_email = 'new_email@example.org'
        existant_client = create(:client)
        admin = create(:admin)
        group = create(:group, members: [ existant_client ])
        sign_in admin

        post :add_user, { id: group.id, email: new_client_email }, format: :json

        expect(response.body).to eq I18n.t('invitation.flash_messages.success', email: new_client_email)
        expect(group.reload.members.map(&:email)).to match_array([existant_client.email, new_client_email])
      end
    end

    it 'can not add a member' do
      client = create(:client)
      group = create(:group)

      post :add_user, { id: group.id, email: client.email }, format: :json

      expect(Group.first.members).to eq []
    end

    it 'can not add a member twice' do
      client = create(:client)
      admin = create(:admin)
      group = create(:group, members: [ client ])
      sign_in admin

      post :add_user, { id: group.id,  email: client.email }, format: :json

      expect(group.reload.members.map(&:email)).to eq [client.email]
      expect(response.body).to eq I18n.t('invitation.flash_messages.invited_user', email: client.email)
    end

    it 'invites if the user is a new user' do
      email = 'jane@doe.org'
      group = create(:group)
      admin = create(:admin)
      sign_in admin

      post :add_user, { id: group.id,  email: email }, format: :json

      expect(response.body).to eq I18n.t('invitation.flash_messages.success', email: email)
      expect(Invitation.all.size).to eq 1
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end
  end
end
