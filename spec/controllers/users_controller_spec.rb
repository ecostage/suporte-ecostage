require 'spec_helper'

describe UsersController do
  describe 'PATCH accept_invite' do
    context 'with invalid token' do
      it 'redirects to sign up user form' do
        patch :accept_invite, { user: {password: 'teste', password_confirmation: 'teste'}, invited_user_token: 'invalid_token' }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with valid token' do
      it 'activates the pending user' do
        client = create(:client, status: :pending)
        invitation = create(:invitation, user: client)
        patch :accept_invite, { user: {password: 'teste123456', password_confirmation: 'teste123456'}, invited_user_token: invitation.token  }

        expect(response).to redirect_to dashboard_path
        expect(client.reload.status).to eq 'active'
      end

      it 'invalidates the current token' do
        client = create(:client, status: :pending)
        invitation = create(:invitation, user: client)
        patch :accept_invite, { user: {password: 'teste123456', password_confirmation: 'teste123456'}, invited_user_token: invitation.token  }

        expect(invitation.reload.stale?).to eq true
      end
    end

    context 'with a token that is stale' do
      it 'redirects to new_user_registrations_path' do
        invitation = create(:invitation, stale: true)
        patch :accept_invite, { user: {password: 'teste', password_confirmation: 'teste'}, invited_user_token: invitation.token }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
