class RemoveChannelIdsFromInvitation < ActiveRecord::Migration
  def change
    remove_column :invitations, :channel_ids
    remove_column :invitations, :group_id
    remove_column :invitations, :email
    remove_column :invitations, :user_type
    add_column :invitations, :user_id, :integer, :references=>:users
  end
end
