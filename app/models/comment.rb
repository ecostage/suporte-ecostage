class Comment < ActiveRecord::Base
  belongs_to :ticket, touch: true
  belongs_to :author, class_name: 'User'
  validates_presence_of :ticket

  scope :recently_first, -> { all.order('created_at DESC') }
end
