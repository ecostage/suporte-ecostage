class NotifierPreview < ActionMailer::Preview
  def created_ticket
    ticket = Ticket.where(subject: 'Created Ticket', status: Ticket.statuses[:unread]).first ||
      FactoryGirl.create(:ticket, subject: 'Created Ticket', channel: channel, created_by: client)
    notification = Notification.new(notifiable: ticket, created_by: client, action: :created)

    NotificationMailer.instructions(notification)
  end

  def canceled_ticket
    ticket = Ticket.where(subject: 'Canceled Ticket', status: Ticket.statuses[:canceled], cancel_reason: 'cancel reason').first ||
      FactoryGirl.create(:ticket, subject: 'Canceled Ticket', channel: channel, status: :canceled, created_by: client, cancel_reason: 'cancel reason')

    notification = Notification.new(notifiable: ticket, created_by: client, action: :canceled)

    NotificationMailer.instructions(notification)
  end

  def approved_ticket
    ticket = Ticket.where(subject: 'Approved Ticket', status: Ticket.statuses[:approved]).first ||
      FactoryGirl.create(:ticket, subject: 'Approved Ticket', channel: channel, status: :approved, created_by: client)

    notification = Notification.new(notifiable: ticket, created_by: client, action: :approved)

    NotificationMailer.instructions(notification)
  end

  def done_ticket
    ticket = Ticket.where(subject: 'Done Ticket', status: Ticket.statuses[:done]).first ||
      FactoryGirl.create(:ticket, subject: 'Done Ticket', channel: channel, status: :done, created_by: client)

    notification = Notification.new(notifiable: ticket, created_by: client, action: :done)

    NotificationMailer.instructions(notification)
  end

  def assigned_ticket
    ticket = Ticket.where(subject: 'Assigned Ticket', status: Ticket.statuses[:in_progress], assign_to: attendant).first ||
      FactoryGirl.create(:ticket, subject: 'Assigned Ticket', channel: channel, status: :in_progress, created_by: client, assign_to: attendant)

    notification = Notification.new(notifiable: ticket, created_by: attendant, action: :assigned)

    NotificationMailer.instructions(notification)
  end

  private

  def attendant
    @attendant ||= User.attendant.find_by_name('Attendant') || FactoryGirl.create(:attendant, name: 'Attendant')
  end

  def channel
    @channel ||= Channel.find_by_name('Channel') || FactoryGirl.create(:channel, name: 'Channel')
  end

  def group
    @group ||= Group.find_by_name('Group') || FactoryGirl.create(:group, name: 'Group')
  end

  def client
    @client ||= User.find_by_name('Client') || FactoryGirl.create(:client, name: 'Client', group: group)
  end
end
