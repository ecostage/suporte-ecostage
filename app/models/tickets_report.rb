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

  def opened_tickets
    @opened_tickets ||= resource_entity.where(created_at: period)
  end

  protected

  def resource_entity
    Ticket
  end
end
