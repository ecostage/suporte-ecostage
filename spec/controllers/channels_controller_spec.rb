require 'spec_helper'

describe ChannelsController do
  let(:valid_attributes) {
    {
      name: "General",
      purpose: "General channel for all purposes"
    }
  }

  let(:invalid_attributes) {
    {
      name: ""
    }
  }

  let(:valid_session) { {} }

  describe "POST create" do
    context 'clients are not allowed to create a channel' do
      it "redirects to root path" do
        client = create(:client)
        sign_in(client)

        post :create, {:channel => valid_attributes}

        expect(response).to redirect_to unauthenticated_user_root_path
      end
    end

    describe "with valid params" do
      it "creates a new Channel and redircts to channels/:id" do
        admin = create(:admin)
        sign_in(admin)

        post :create, {:channel => valid_attributes}

        expect(Channel.all.size).to eq(1)
        expect(response).to redirect_to(channel_tickets_path(Channel.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved channel as @channel" do
        admin = create(:admin)
        sign_in(admin)

        post :create, {:channel => invalid_attributes}

        expect(assigns(:channel)).to be_a_new(Channel)
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:new_attributes) {
      {
        name: "General 2"
      }
    }

    describe 'Checking authorization' do
      context 'clients are not allowed to update a channel' do
        it 'redirects to root_path' do
          client = create(:client)
          channel = create(:channel)
          sign_in(client)

          put :update, {:id => channel.to_param, :channel => new_attributes}

          expect(response).to redirect_to unauthenticated_user_root_path
        end
      end

      context 'admin are allowed to update a channel' do
        it 'redirects to root_path' do
          client = create(:admin)
          channel = create(:channel)
          sign_in(client)

          put :update, {:id => channel.to_param, :channel => new_attributes}

          expect(response).to redirect_to(channel)
        end
      end
    end

    describe "with valid params" do
      it "updates the requested channel" do
        channel = create(:channel_with_members)
        sign_in(channel.members.first)

        put :update, {:id => channel.to_param, :channel => new_attributes }
        channel.reload

        expect(channel.name).to eq(new_attributes[:name])
        expect(assigns(:channel)).to eq(channel)
        expect(response).to redirect_to(channel)
      end
    end

    describe "with invalid params" do
      it "assigns @channel and renders edit" do
        channel = create(:channel_with_members)
        sign_in(channel.members.first)
        put :update, {:id => channel.to_param, :channel => invalid_attributes}

        expect(assigns(:channel)).to eq(channel)
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    context 'clients are not allowed' do
      it 'redirects to root_path' do
        client = create(:client)
        channel = create(:channel)
        sign_in(client)
        delete :destroy, {:id => channel.to_param}

        expect(response).to redirect_to(authenticated_user_root_path)
      end
    end

    it "destroys the requested channel" do
      admin = create(:admin)
      sign_in(admin)
      channel = create(:channel)
      expect {
        delete :destroy, {:id => channel.to_param}
      }.to change(Channel, :count).by(-1)
    end

    it "redirects to the channels list" do
      attendant = create(:attendant)
      sign_in(attendant)
      channel = create(:channel)
      delete :destroy, {:id => channel.to_param}
      expect(response).to redirect_to(channels_url)
    end
  end
end
