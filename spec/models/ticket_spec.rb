require 'spec_helper'

describe Ticket do
  let(:ticket) { FactoryGirl.create(:ticket) }
  let!(:group) { create(:group, members: [client, client2]) }
  let(:attendant) { create(:attendant) }
  let(:client) { create(:client) }
  let(:client2) { create(:client) }
  let(:alone_client) { create(:client) }

  describe 'associations' do
    it { should have_many(:comments) }
    it { should belong_to(:channel) }
  end

  it 'should humanize status' do
    expect(ticket.status_humanized).to eq(I18n.translate("ticket.statuses.#{ticket.status}"))
  end

  describe '#user_scope' do
    let(:client_ticket) { create(:ticket, created_by: client) }
    let(:client2_ticket) { create(:ticket, created_by: client2) }
    let(:alone_client_ticket) { create(:ticket, created_by: alone_client) }

    it 'should scope by user permission' do
      attendant_tickets = [alone_client_ticket, client_ticket]

      expect(Ticket.user_scope(alone_client)).to contain_exactly(alone_client_ticket)
      expect(Ticket.user_scope(attendant)).to contain_exactly(*attendant_tickets)
    end

    it 'should scope by user group' do
      tickets = [client_ticket, client2_ticket]
      expect(Ticket.user_scope(client)).to contain_exactly(*tickets)
    end
  end

  describe '#old?' do
    context 'ticket older than 15 days' do
      subject {
        create(:ticket, updated_at: 16.days.ago)
      }

      it { expect(subject.old?).to be_truthy }
    end

    context 'ticket newer than 15 days' do
      subject {
        create(:ticket, updated_at: 10.days.ago)
      }

      it { expect(subject.old?).to be_falsy }
    end
  end

  describe '#after_find' do
    it 'sends auto_approve!', :vcr do
      create(:ticket, updated_at: 16.days.ago, status: :done)
      ticket = Ticket.last
      expect(ticket.status).to eq('approved')
    end
  end

  describe '#hours_taken' do
    let(:ticket) {
      create(:ticket, created_at: created_at, resolved_at: resolved_at)
    }
    let(:created_at) { Time.zone.local(2015, 5, 11, 10) }
    let(:resolved_at) { Time.zone.local(2015, 5, 11, 12) }

    it 'returns the hours taken for ticket resolution' do
      expect(ticket.hours_taken).to eq(2)
    end

    context 'through the night' do
      let(:created_at) { Time.zone.local(2015, 5, 11, 17) }
      let(:resolved_at) { Time.zone.local(2015, 5, 12, 10) }
      it 'does not count hours out of workhour' do
        expect(ticket.hours_taken).to eq(2)
      end
    end
  end
end
