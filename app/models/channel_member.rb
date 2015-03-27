class ChannelMember < ActiveRecord::Base
  belongs_to :channel
  belongs_to :member, class_name: "User", foreign_key: 'user_id'
end
