class MetricsController < ApplicationController
  def show
    @channels_metrics = Channel.user_scope(current_user).map do |channel|
      TicketMetric.new channel.tickets, channel
    end

    @groups_metrics = [Group.user_scope(current_user)].flatten.map do |group|
      tickets = group.members.reduce [] do |tickets, user|
        tickets.concat(user.tickets)
      end
      TicketMetric.new tickets, group
    end
  end
end
