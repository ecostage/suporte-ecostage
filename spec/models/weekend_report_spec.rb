require 'spec_helper'

RSpec.describe WeekendReport do
  let(:report) { described_class.new(date) }
  let(:date) { Date.today }

  describe '#opened_tickets' do
    subject(:tickets) { report.opened_tickets }
    let!(:old_ticket) { create(:ticket, created_at: date.prev_week.end_of_week) }
    let!(:new_ticket) { create(:ticket, created_at: date) }

    it 'contains new ticket' do
      expect(tickets).to include(new_ticket)
    end

    it 'does not contain the old ticket' do
      expect(tickets).not_to include(old_ticket)
    end
  end

  describe '#solved_tickets' do
    subject(:tickets) { report.solved_tickets }
    let!(:old_ticket) { create(:ticket, created_at: date.prev_week.end_of_week) }
    let!(:unsolved_ticket) { create(:ticket, created_at: date, resolved_at: nil) }
    let!(:solved_ticket) { create(:ticket, created_at: date, resolved_at: Time.current) }

    it 'contains solved ticket' do
      expect(tickets).to include(solved_ticket)
    end

    it 'does not contain the old ticket' do
      expect(tickets).not_to include(old_ticket)
    end

    it 'does not contain the unsolved ticket' do
      expect(tickets).not_to include(unsolved_ticket)
    end
  end

  describe '#attended_tickets' do
    subject(:tickets) { report.attended_tickets }
    let!(:old_ticket) { create(:ticket, created_at: date.prev_week.end_of_week) }
    let!(:unsolved_ticket) { create(:ticket, created_at: date, resolved_at: nil) }
    let!(:unattended_ticket) do
      create(:ticket, created_at: date, resolved_at: nil, attended_at: nil)
    end
    let!(:attended_ticket) { create(:ticket, attended_at: Time.now) }
    let!(:solved_ticket) { create(:ticket, created_at: date) }

    it 'contains attended ticket' do
      expect(tickets).to include(attended_ticket)
    end

    it 'does not contain the old ticket' do
      expect(tickets).not_to include(old_ticket)
    end
  end
end
