require 'spec_helper'

describe TicketAutoApproval, :vcr do
  describe '#auto_approve!' do
    before(:each) do
      user = create(:user)
      allow(ticket).to receive(:approved!)
      allow(ticket).to receive(:created_by) { user }
    end

    subject { TicketAutoApproval.new(ticket) }

    context 'old ticket' do
      let(:ticket) { double('Ticket', old?: true, done?: true) }

      it 'approves the ticket' do
        allow(Comment).to receive(:create)
        subject.auto_approve!
        expect(ticket).to have_received(:approved!)
        expect(Comment).to have_received(:create)
      end
    end

    context 'new ticket' do
      let(:ticket) { double('Ticket', old?: false, done?: true) }

      it 'does not approves the ticket' do
        subject.auto_approve!
        expect(ticket).not_to have_received(:approved!)
      end
    end

    context 'ticket is not done' do
      let(:ticket) { double('Ticket', old?: true, done?: false) }

      it 'does not approves the ticket' do
        subject.auto_approve!
        expect(ticket).not_to have_received(:approved!)
      end
    end
  end
end
