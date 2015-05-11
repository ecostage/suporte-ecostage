class TicketMetric < BaseMetric
  def per_status
    data = @tickets.reduce HashWithIndifferentAccess.new do |hash, ticket|
      unless hash[ticket.status].present?
        hash[ticket.status] = 0
      end
      hash[ticket.status] += 1
      hash
    end
    data.instance_eval do
      def to_chart
        self.map do |status, value|
          {
            value: value,
            color: Ticket.statuses_color[status],
            label: Ticket.humanize_status(status)
          }
        end
      end
    end
    data
  end

  def avg_resolution_time
    unless @tickets.map(&:hours_taken).empty?
      (@tickets.map(&:hours_taken).reduce(:+) / @tickets.size).to_i
    else
      0
    end
  end

  def avg_sla
    unless @tickets.map(&:sla).empty?
      @tickets.map(&:sla).reduce(:+) / @tickets.size
    else
      0
    end
  end
end
