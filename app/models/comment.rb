class Comment < ActiveRecord::Base
  belongs_to :ticket, touch: true
  belongs_to :author, class_name: 'User'
  validates_presence_of :ticket

  scope :recently_first, -> { all.order('created_at DESC') }

  has_attached_file :attachment, styles: {
    thumb: '100x100#'
  }, :size => { :in => 0..25.megabytes },
  whiny: false

  validates_attachment_content_type :attachment, :content_type => [/\Aimage\/.*\Z/, /\Aapplication\/.*\Z/, /\Atext\/.*\Z/]
end
