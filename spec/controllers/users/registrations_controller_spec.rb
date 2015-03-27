require 'spec_helper'

describe Users::RegistrationsController do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET index' do
    context 'users with invalid token' do
      it 'redirects to users signup' do
        get :new, invite_token: 123

        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'users with valid token' do
      it 'renders a new_invited_user form' do
        invitation = create(:invitation)
        get :new, invite_token: invitation.token

        expect(response).to render_template('devise/registrations/new_invited_user')
      end
    end

    context 'with a stale invitation' do
      it 'rendirects a new_user_registration_path form' do
        invitation = create(:invitation, stale: true)
        get :new, invite_token: invitation.token

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
