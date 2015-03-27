class Notification < ActiveRecord::Base
  belongs_to :notifiable, polymorphic: true
  belongs_to :created_by, class: User

  def action_id
    "notifications.#{namespace}.#{action}"
  end

  def template
    "notifications/#{namespace}/#{action}"
  end

  def namespace
    notifiable.class.name.downcase
  end

  def subject
    I18n.translate action_id, context
  end

  def deliver
    if recipients.present? and !recipients.empty?
      NotificationMailer.instructions(self).deliver
    end
  end

  def recipients
    notifiable.recipients_for(action)
  end

  def context
    notifiable.context_for(action).merge({
      actor: created_by.email,
      created_at: created_at
    })
  end
end
