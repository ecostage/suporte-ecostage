class DashboardsController < ApplicationController
  def show
    @tickets = TicketPolicy::Scope.new(current_user, Ticket.all).
      resolve.recently_first.limit(20)
  end
end
