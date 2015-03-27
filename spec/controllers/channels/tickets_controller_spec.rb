require 'spec_helper'

describe Channels::TicketsController do
  let(:valid_attributes) {
    {
      subject: "Ticket subject",
      content: "Ticket content",
      is_priority: false,
      estimated_time: 1,
      status: :unread,
      complexity: 1,
      resolved_at: "2014-09-17 12:12:23",
      attended_at: "2014-09-17 12:12:23",
      created_by: create(:client)
    }
  }

  let(:invalid_attributes) {
    {
      subject: "",
      content: "",
      is_priority: false,
      estimated_time: 1,
      status: :unread,
      complexity: 1,
      resolved_at: "2014-09-17 12:12:23",
      attended_at: "2014-09-17 12:12:23"
    }
  }

  let(:ticket) { channel.tickets.create valid_attributes }

  let(:channel) { FactoryGirl.create(:channel) }
  let(:channel_with_tickets) { FactoryGirl.create(:channel_with_tickets) }
  let(:attendant) { FactoryGirl.create(:attendant) }
  let(:client) { FactoryGirl.create(:client) }
  let(:admin) { FactoryGirl.create(:admin) }


  describe "GET index" do
    it "assigns channel tickets as @tickets" do
      sign_in attendant
      channel.members << attendant
      get :index, {channel_id: channel}
      expect(assigns(:tickets)).to eq([ticket])
    end

    it "shows only tickets related with channel" do
      sign_in attendant
      channel_with_tickets.members << attendant
      Ticket.create! valid_attributes
      get :index, {channel_id: channel_with_tickets}
      expect(assigns(:tickets)).to eq(channel_with_tickets.tickets)
    end
  end

  describe "GET show" do
    it "assigns the requested ticket as @ticket" do
      sign_in attendant
      get :show, {channel_id: channel, :id => ticket.to_param}
      expect(assigns(:ticket)).to eq(ticket)
    end
  end

  describe "GET new" do
    it "assigns a new ticket as @ticket" do
      sign_in client
      get :new, {channel_id: channel}
      expect(assigns(:ticket)).to be_a_new(Ticket)
    end
  end

  describe "GET edit" do
    it "assigns the requested ticket as @ticket" do
      sign_in attendant
      get :edit, {channel_id: channel, :id => ticket.to_param}
      expect(assigns(:ticket)).to eq(ticket)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Ticket" do
        sign_in client
        expect {
          post :create, {channel_id: channel, :ticket => valid_attributes}
        }.to change(Ticket, :count).by(1)
      end

      it "assigns a newly created ticket as @ticket" do
        sign_in client
        post :create, {channel_id: channel, :ticket => valid_attributes}
        expect(assigns(:ticket)).to be_a(Ticket)
        expect(assigns(:ticket)).to be_persisted
      end

      it "redirects to the created ticket" do
        sign_in client
        post :create, {channel_id: channel, :ticket => valid_attributes}
        expect(response).to redirect_to(channel_ticket_url(channel, Ticket.last))
      end

      it "ticket should belong to the channel" do
        sign_in client
        post :create, {channel_id: channel, :ticket => valid_attributes}
        expect(assigns(:ticket).channel).to eq(channel)
      end

      it "ticket should belong to current_user" do
        sign_in client
        post :create, {channel_id: channel, :ticket => valid_attributes}
        expect(assigns(:ticket).created_by).to eq(client)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ticket as @ticket" do
        sign_in client
        post :create, {channel_id: channel, :ticket => invalid_attributes}
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end

      it "re-renders the 'new' template" do
        sign_in client
        post :create, {channel_id: channel, :ticket => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          subject: "Ticket subject",
          content: "Ticket content",
          is_priority: false,
          estimated_time: 1,
          complexity: 1,
          resolved_at: "2014-09-17 12:12:23",
          attended_at: "2014-09-17 12:12:23"
        }
      }

      it "updates the requested ticket" do
        sign_in attendant
        put :update, {channel_id: channel, :id => ticket.to_param, :ticket => new_attributes}
        ticket.reload
        expect(ticket.subject).to eq(new_attributes[:subject])
      end

      it "assigns the requested ticket as @ticket" do
        sign_in attendant
        put :update, {channel_id: channel, :id => ticket.to_param, :ticket => valid_attributes}
        expect(assigns(:ticket)).to eq(ticket)
      end

      it "redirects to the ticket" do
        sign_in attendant
        put :update, {channel_id: channel, :id => ticket.to_param, :ticket => valid_attributes}
        expect(response).to redirect_to(channel_ticket_url(channel, ticket))
      end
    end

    describe "with invalid params" do
      it "assigns the ticket as @ticket" do
        sign_in attendant
        put :update, {channel_id: channel, :id => ticket.to_param, :ticket => invalid_attributes}
        expect(assigns(:ticket)).to eq(ticket)
      end

      it "re-renders the 'edit' template" do
        sign_in attendant
        put :update, {channel_id: channel, :id => ticket.to_param, :ticket => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested ticket" do
      sign_in create(:admin)
      ticket
      expect {
        delete :destroy, {channel_id: channel, :id => ticket.to_param}
      }.to change(Ticket, :count).by(-1)
    end

    it "redirects to the tickets list" do
      sign_in create(:admin)
      delete :destroy, {channel_id: channel, :id => ticket.to_param}
      expect(response).to redirect_to(channel_tickets_url(channel))
    end
  end

  describe "Ticket events: " do
    it "if opened by a attendant and unread change to in progress" do
      sign_in attendant
      ticket = create(:unread_ticket)
      get :show, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.in_progress?).to be_truthy
      expect(ticket.attended_at).to be_truthy
    end

    it "if opened by a admin and unread change to in progress" do
      sign_in admin
      ticket = create(:unread_ticket)
      get :show, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.in_progress?).to be_truthy
      expect(ticket.attended_at).to be_truthy
    end

    it "if status different of unread never change status opening" do
      sign_in attendant
      ticket = create(:in_progress_ticket)
      get :show, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.in_progress?).to be_truthy
    end

    it "if opened by a client never change status opening" do
      channel = create(:channel)
      group = create(:group, channels: [channel])
      client = create(:client, group: group)
      sign_in client
      ticket = create(:unread_ticket)
      get :show, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.unread?).to be_truthy
    end

    it "ticket done by a attendant" do
      channel = create(:channel)
      sign_in attendant
      ticket = create(:in_progress_ticket, channel: channel)
      put :done, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.done?).to be_truthy
    end

    it "ticket cannot be done by a client" do
      channel = create(:channel)
      sign_in client
      ticket = create(:in_progress_ticket, channel: channel)
      put :done, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.in_progress?).to be_truthy
    end

    it "ticket cannot be approved by a attendant" do
      channel = create(:channel)
      sign_in attendant
      ticket = create(:done_ticket, channel: channel)
      put :approve, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.done?).to be_truthy
    end

    it "ticket approved by a client" do
      sign_in client
      ticket = create(:done_ticket)
      ticket.update created_by: client
      put :approve, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.approved?).to be_truthy
    end

    it "ticket cannot be reproved by a attendant" do
      sign_in attendant
      ticket = create(:done_ticket)
      put :reprove, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.done?).to be_truthy
    end

    it "ticket reproved by a client" do
      sign_in client
      ticket = create(:done_ticket)
      ticket.update created_by: client
      put :reprove, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.reproved?).to be_truthy
      expect(ticket.resolved_at).to be(nil)
    end

    it "ticket can be cancelled by the attendant" do
      channel = create(:channel)
      sign_in attendant
      ticket = create(:done_ticket, channel: channel)
      put :cancel, { channel_id: channel, :id => ticket.id, reason: "Reason for cancel ticket" }
      ticket.reload
      expect(ticket.canceled?).to be_truthy
      expect(ticket.cancel_reason.present?).to be_truthy
    end

    it "ticket cant be cancelled without a reason" do
      sign_in attendant
      ticket = create(:done_ticket)
      put :cancel, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.canceled?).to be_falsy
    end

    it "ticket cant change status if approved" do
      sign_in client
      ticket = create(:approved_ticket)
      ticket.update created_by: client
      put :reprove, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.approved?).to be_truthy

      put :done, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.approved?).to be_truthy

      put :cancel, { channel_id: channel, :id => ticket.id }
      ticket.reload
      expect(ticket.approved?).to be_truthy
    end
  end

  describe "Sends notification" do
    it 'when ticket is created' do
      sign_in client
      channel.members << attendant
      expect {
        post :create, {channel_id: channel, :ticket => valid_attributes, format: :json}
        expect(response).to have_http_status(:success)
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'when ticket is done' do
      channel = create(:channel)
      sign_in attendant

      ticket = create(:in_progress_ticket, channel: channel)
      ticket.update created_by: client

      expect {
        put :done, { channel_id: channel, :id => ticket.id }
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(response).to have_http_status(:success)
    end

    it "when ticket is approved" do
      channel = create(:channel)
      sign_in client
      ticket = create(:done_ticket, channel: channel)
      ticket.update assign_to: attendant, created_by: client

      expect {
        put :approve, { channel_id: channel, :id => ticket.id }
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(response).to have_http_status(:success)
    end

    it "when ticket is reproved" do
      channel = create(:channel)
      sign_in client
      ticket = create(:done_ticket, channel: channel)
      ticket.update assign_to: attendant, created_by: client

      expect {
        put :reprove, { channel_id: channel, :id => ticket.id }
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(response).to have_http_status(:success)
    end

    it "when ticket is canceled" do
      channel = create(:channel)
      sign_in attendant
      ticket = create(:done_ticket, channel: channel)
      ticket.update assign_to: attendant, created_by: client

      expect {
        put :cancel, { channel_id: channel, :id => ticket.id, reason: "Reason" }
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'ticket search' do
    it 'returns a filtered list of tickets' do
      sign_in attendant
      ticket1 = create(:ticket)
      ticket1.update subject: 'Ticket 01', content: 'Lorem ipsum'
      ticket2 = create(:ticket)
      ticket2.update subject: 'Ticket 02', content: 'Ticket 02'
      channel.tickets = [ticket1, ticket2]

      get :index, {channel_id: channel, search: 'Ticket'}
      expect(assigns(:tickets)).to contain_exactly(ticket1, ticket2)

      get :index, {channel_id: channel, search: '01'}
      expect(assigns(:tickets)).to contain_exactly(ticket1)

      get :index, {channel_id: channel, search: 'Lorem'}
      expect(assigns(:tickets)).to contain_exactly(ticket1)

      get :index, {channel_id: channel, search: '02'}
      expect(assigns(:tickets)).to contain_exactly(ticket2)
    end
  end
end
