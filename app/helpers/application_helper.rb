module ApplicationHelper
  def channels
    Channel.user_scope(current_user)
  end

  def active_channel?(channel)
    if @channel
      @channel.eql? channel
    end
  end

  def channel_has_notification?(channel)
    channel_notification_number(channel) > 0
  end

  def channel_notification_number(channel)
    unless current_user.client?
      scope = channel.tickets.user_scope(current_user)
      scope.unread.size+scope.reproved.size
    else
      channel.tickets.user_scope(current_user).done.size
    end
  end

  def chart(data, options={}, html_options={})
    options.merge!({
      data: data.to_chart.to_json,
    })
    html_options.merge!({
      data: options
    })
    content_tag :canvas, '', html_options
  end

  def sla(sla)
    (1..5).each do |bullet_sla|
      opt_class = sla >= bullet_sla ? '' : 's-dis'
      yield(icon :circle, '', class: "s-#{bullet_sla} #{opt_class}")
    end
  end

  def resolution_sla(ticket)
    sla(ticket.sla) do |icon|
      yield(icon)
    end
  end

  def bootstrap_class_for flash_type
    case flash_type.to_sym
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :alert
        "alert-warning"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def complexity_image(ticket, context)
    if not ticket.unread? and ticket.complexity
      context.image_tag "stamps/complexity-#{ticket.complexity}.png",
                        class: 'img-circle complexity',
                        title: "Complexidade #{ticket.complexity}"
    end
  end
end
