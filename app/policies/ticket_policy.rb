class TicketPolicy < Struct.new(:user, :ticket)
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.user_scope(user)
    end
  end

  def new?
    user.client?
  end

  def show?
    !user.client? or ticket.created_by == user or user.group.channels.include? ticket.channel
  end

  def edit?
    !user.client? or ticket.created_by == user
  end

  def update?
    !user.client? or ticket.created_by == user
  end

  def approve?
    ticket.created_by == user and ticket.done? and !ticket.approved?
  end

  def reprove?
    ticket.created_by == user and ticket.done? and !ticket.reproved?
  end

  def done?
    !user.client? and !ticket.approved? and !ticket.done?
  end

  def in_progress?
    !user.client? and ticket.unread?
  end

  def create?
    user.client?
  end

  def cancel?
    !user.client? and !ticket.approved? and !ticket.canceled?
  end

  def destroy?
    user.admin? or ticket.unread?
  end

  def download?
    show?
  end
end
