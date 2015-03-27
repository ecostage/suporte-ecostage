require 'spec_helper'

describe TicketMetric do
  describe 'per_status' do
    it 'returns a metric hash based on status' do
      tickets = []
      2.times.each do
        ticket = create(:ticket)
        ticket.unread!
        tickets << ticket
      end

      3.times.each do
        ticket = create(:ticket)
        ticket.in_progress!
        tickets << ticket
      end

      4.times.each do
        ticket = create(:ticket)
        ticket.done!
        tickets << ticket
      end

      2.times.each do
        ticket = create(:ticket)
        ticket.canceled!
        tickets << ticket
      end

      2.times.each do
        ticket = create(:ticket)
        ticket.approved!
        tickets << ticket
      end

      3.times.each do
        ticket = create(:ticket)
        ticket.reproved!
        tickets << ticket
      end

      metric = TicketMetric.new(tickets)
      metric_hash = metric.per_status

      expect(metric_hash[:unread]).to eq(2)
      expect(metric_hash[:in_progress]).to eq(3)
      expect(metric_hash[:done]).to eq(4)
      expect(metric_hash[:canceled]).to eq(2)
      expect(metric_hash[:approved]).to eq(2)
      expect(metric_hash[:reproved]).to eq(3)
    end
  end

  describe 'avg resolution time' do
    it 'returns the avg time of tickets resolution in hours' do
      tickets = []
      now = DateTime.now
      hours_ago_4 = now-4.hours
      hours_ago_2 = now-2.hours
      hours_ago_3 = now-3.hours

      ticket = create(:ticket)
      ticket.approved!
      ticket.update created_at: hours_ago_4, resolved_at: now
      tickets << ticket

      ticket = create(:ticket)
      ticket.approved!
      ticket.update created_at: hours_ago_2, resolved_at: now
      tickets << ticket

      ticket = create(:ticket)
      ticket.approved!
      ticket.update created_at: hours_ago_3, resolved_at: now
      tickets << ticket

      metric = TicketMetric.new(tickets)
      hours = metric.avg_resolution_time
      expect(hours).to eq(3)
    end
  end

  describe 'avg sla' do
    it 'avg sla status' do
      tickets = []
      now = DateTime.now
      hours_ago_5 = now-5.hours
      hours_ago_4 = now-4.hours
      hours_ago_3 = now-3.hours

      ticket = create(:ticket)
      ticket.approved!
      ticket.update created_at: hours_ago_5, resolved_at: now, estimated_time: 5
      tickets << ticket

      ticket = create(:ticket)
      ticket.approved!
      ticket.update created_at: hours_ago_4, resolved_at: now, estimated_time: 5
      tickets << ticket

      ticket = create(:ticket)
      ticket.approved!
      ticket.update created_at: hours_ago_3, resolved_at: now, estimated_time: 5
      tickets << ticket

      metric = TicketMetric.new(tickets)
      hours = metric.avg_sla
      expect(hours).to eq(4)
    end
  end
end
