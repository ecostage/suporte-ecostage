class Channel < ActiveRecord::Base
  include Notifiable
  validates :name, uniqueness: true, presence: true
  has_many :channel_members, dependent: :destroy
  has_many :members, through: :channel_members
  has_many :tickets
  has_many :group_channels
  has_many :groups, through: :group_channels

  scope :user_scope, -> (user) {
    if user.client? and user.group.present?
      user.group.channels
    else
      all
    end
  }

  def new_member(user)
    members << user
    user
  end

  def name_with_hashtag
    "##{name}"
  end

  def add_ticket(ticket)
    tickets << ticket
    ticket
  end
end
