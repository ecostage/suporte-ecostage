class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :group
  has_many :comments, foreign_key: 'author_id'
  has_many :tickets, foreign_key: 'created_by_id'

  enum user_type: [:client, :attendant, :admin, :robot]
  enum status: [:active, :inactive, :pending]

  has_attached_file :avatar, styles: {
    thumb: '64x64#',
    square: '150x150#',
    medium: '300x300>'
  },
  :size => { :in => 0..2.megabytes },
  default_url: ':attachment/:style/missing.jpg'

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def siblings
    if self.group.nil?
      [self]
    else
      self.group.members.all
    end
  end

  def as_recipient
    "#{name} <#{email}>"
  end

  def invite(invitation_params)
    if self.client?
      invitation_params.merge!(user_type: :client, sender: self, group_id: self.group_id)
    else
      invitation_params.merge!(user_type: :attendant, sender: self)
    end

    Invitation.invite(invitation_params)
  end
end
