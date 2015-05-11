require 'spec_helper'

describe TicketMetric do
  Ticket.statuses.each do |status, _|
    let(status.to_sym) { create(:ticket, status.to_sym) }
  end

  let(:resolved_at) { Time.new(2015, 5, 11, 17) }
  let(:four_hours_taken) { resolved_at-4.hours }
  let(:three_hours_taken) { resolved_at-3.hours }
  let(:two_hours_taken) { resolved_at-2.hours }
  let(:ticket1) {
    create(:ticket, :approved, created_at: four_hours_taken, resolved_at: resolved_at)
  }
  let(:ticket2) {
    create(:ticket, :approved, created_at: two_hours_taken, resolved_at: resolved_at)
  }
  let(:ticket3) {
    create(:ticket, :approved, created_at: three_hours_taken, resolved_at: resolved_at)
  }

  describe 'per_status' do
    it 'returns a metric hash based on status' do
      tickets = [unread, done, in_progress, canceled, approved, reproved]
      metric = TicketMetric.new(tickets)
      metric_hash = metric.per_status

      Ticket.statuses.each do |status, _|
        expect(metric_hash[status.to_sym]).to eq(1)
      end
    end
  end

  describe 'avg resolution time' do
    it 'returns the avg time of tickets resolution in hours' do
      tickets = [ticket1, ticket2, ticket3]

      metric = TicketMetric.new(tickets)
      hours = metric.avg_resolution_time
      expect(hours).to eq(3)
    end
  end

  describe 'avg sla' do
    it 'avg sla status' do
      tickets = [ticket1, ticket2, ticket3]

      metric = TicketMetric.new(tickets)
      sla_points = metric.avg_sla
      expect(sla_points).to eq(3)
    end
  end
end
