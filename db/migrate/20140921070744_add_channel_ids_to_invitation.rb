class AddChannelIdsToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :channel_ids, :integer, array: true
  end
end
