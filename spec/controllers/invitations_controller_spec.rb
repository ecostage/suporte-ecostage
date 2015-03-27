require 'spec_helper'

describe InvitationsController do
  describe 'POST create' do
    context 'create a existant user' do
      it 'redirects renders new with a flash message' do
        client = create(:client)
        existing_client = create(:client)
        sign_in client
        post :create, invitation: { email: existing_client.email, channel_ids: [] }

        expect(flash[:error]).not_to be_nil
      end
    end

    context 'create a existant user' do
      it 'redirects renders new with a flash message' do
        client = create(:user)
        pending_user = create(:user, status: :pending)
        existing_invitation = Invitation.create! user: pending_user
        sign_in client
        post :create, invitation: { email: existing_invitation.user.email, channel_ids: [] }

        expect(flash[:error]).not_to be_nil
      end
    end
  end
end
