class WeekendReport
  attr_accessor :date

  def initialize(date)
    @date = date
  end

  def attended_tickets
    opened_tickets.attended
  end

  def solved_tickets
    opened_tickets.solved
  end

  def opened_tickets
    resource_entity.where(created_at: date.all_week)
  end

  protected

  def resource_entity
    Ticket
  end
end
