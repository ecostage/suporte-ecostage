require 'rspec'
require './app/policies/ticket_policy'

describe TicketPolicy do
  describe '#show?' do
    context 'when the ticket is from a group which he does not belong' do
      it 'returns false' do
        another_user = double
        channel_without_tickets = double('Channel without ticket')
        channel = double('Channel')
        group = double('Group', channels: [channel])
        user = double('User', client?: true, group: group)
        ticket = double('Ticket', created_by: another_user)
        allow(ticket).to receive(:channel) { channel_without_tickets }
        ticket_policy = TicketPolicy.new(user, ticket)

        expect(ticket_policy.show?).to eq false
      end
    end

    context 'when the ticket is from a group which he belongs' do
      it 'returns true' do
        group = double
        another_user = double
        user = double('User', client?: true, group: group)
        channel = double('Channel')
        ticket = double('Ticket', created_by: another_user, channel: channel)
        allow(channel).to receive(:tickets) { [ticket] }
        allow(group).to receive(:channels) { [channel] }
        ticket_policy = TicketPolicy.new(user, ticket)

        expect(ticket_policy.show?).to eq true
      end
    end
  end

  describe '#download?' do
    context 'user signed in' do
      it 'returns true' do
        group = double
        another_user = double
        user = double('User', client?: true, group: group)
        channel = double('Channel')
        ticket = double('Ticket', created_by: another_user, channel: channel)
        allow(channel).to receive(:tickets) { [ticket] }
        allow(group).to receive(:channels) { [channel] }
        ticket_policy = TicketPolicy.new(user, ticket)
        expect(ticket_policy.download?).to eq true
      end
    end
  end
end
