class GroupPolicy
  attr_reader :user
  attr_reader :group

  def initialize(user, group)
    @user = user || User.new
    @group = group
  end

  def new?
    user.admin?
  end

  def index?
    !user.client?
  end

  def edit?
    !user.client?
  end

  def update?
    !user.client?
  end

  def show?
    (!user.client?) || (user.group_ids.include? group.id)
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin?
  end
end
