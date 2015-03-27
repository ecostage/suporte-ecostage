class BaseMetric
  def initialize(tickets, obj=nil)
    @tickets = tickets
    @obj = obj
  end

  def obj
    @obj
  end
end
