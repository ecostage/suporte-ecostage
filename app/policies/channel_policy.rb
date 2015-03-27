class ChannelPolicy < Struct.new(:user, :channel)
  def new?
    !user.client?
  end

  def destroy?
    !user.client?
  end

  def index?
    !user.client?
  end

  def show?
    if user.attendant? or user.admin?
      true
    else
      channel.groups.include? user.group
    end
  end

  def update?
    !user.client?
  end

  def edit?
    !user.client?
  end

  def create?
    !user.client?
  end
end
