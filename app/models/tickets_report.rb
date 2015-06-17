class TicketsReport
  attr_accessor :period

  def initialize(period)
    @period = period
  end

  def attended_tickets
    @attended_tickets ||= opened_tickets.attended
  end

  def solved_tickets
    @solved_tickets ||= opened_tickets.solved
  end

  def average_hours_taken
    opened_tickets.average_hours_taken
  end

  def opened_tickets
    @opened_tickets ||= resource_entity.where(created_at: period)
  end

  protected

  def resource_entity
    Ticket
  end
end
