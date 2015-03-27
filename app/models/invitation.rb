class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :user
  before_create :generate_token

  def subject
    I18n.t('mailer.invitations.subject')
  end

  def send_email
    InvitationMailer.invite(self).deliver
  end

  def self.invite(attributes={})
    unless user = User.where(email: attributes[:email]).pending.first
      user = User.new email: attributes[:email], user_type: attributes[:user_type],
        group_id: attributes[:group_id], status: :pending, password: SecureRandom.hex(32)
    end
    if user.save
      invitation = new(user: user, sender: attributes[:sender])
      if invitation.save
        invitation.send_email
      end
    end
  end

  private

  def generate_token
    self.token = SecureRandom.hex(32)
  end
end
