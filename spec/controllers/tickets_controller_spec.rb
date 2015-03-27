require 'spec_helper'

describe TicketsController do
  describe 'POST /tickets/:id/assign_to' do
    context 'signed in attendant' do
      it 'assigns a attedant to a ticket' do
        channel = create(:channel)
        ticket = create(:ticket, channel: channel)
        attendant = create(:attendant)
        sign_in(attendant)

        post :assign_to, { id: ticket.id, attendant_id: attendant.id }, format: :json
        json = JSON.parse(response.body)

        expect(json['assign_to']).to eq attendant.email
        expect(ticket.reload.assign_to).to eq attendant
      end
    end

    context 'signed in client' do
      it 'renders a 403' do
        ticket = create(:ticket)
        client = create(:client)
        sign_in(client)

        post :assign_to, { id: ticket.id, attendant_id: client.id }, format: :json

        expect(response.code).to eq '403'
      end
    end
  end
end
