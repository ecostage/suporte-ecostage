class Group < ActiveRecord::Base
  has_many :members, class: User

  has_many :group_channels
  has_many :channels, through: :group_channels

  scope :user_scope, -> (user) {
    if user.client?
      user.group
    else
      all
    end
  }

  def invite(email, inviter)
    Invitation.invite(email: email, sender: inviter,
                      group_id: self.id, user_type: :client)
  end
end
