require 'spec_helper'

describe Ticket do
  let(:ticket) { FactoryGirl.create(:ticket) }
  let(:group) { create(:group) }

  describe 'associations' do
    it { should have_many(:comments) }
    it { should belong_to(:channel) }
  end

  it 'should humanize status' do
    expect(ticket.status_humanized).to eq(I18n.translate("ticket.statuses.#{ticket.status}"))
  end

  it 'should scope by user permission' do
    ticket1 = create(:ticket)
    ticket2 = create(:ticket)
    ticket3 = create(:ticket)
    ticket4 = create(:ticket)

    client1 = create(:client)
    client2 = create(:client)
    client3 = create(:client)

    attendant = create(:attendant)

    ticket1.update created_by: client1
    ticket2.update created_by: client2
    ticket3.update created_by: client3
    ticket4.update created_by: client3

    group.members << client1
    group.members << client2

    client1_tickets = [ticket1, ticket2]
    client2_tickets = [ticket1, ticket2]
    client3_tickets = [ticket3, ticket4]
    attendant_tickets = [ticket1, ticket2, ticket3, ticket4]


    expect(Ticket.user_scope(client1)).to contain_exactly(*client1_tickets)
    expect(Ticket.user_scope(client2)).to contain_exactly(*client2_tickets)
    expect(Ticket.user_scope(client3)).to contain_exactly(*client3_tickets)
    expect(Ticket.user_scope(attendant)).to contain_exactly(*attendant_tickets)
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
end
