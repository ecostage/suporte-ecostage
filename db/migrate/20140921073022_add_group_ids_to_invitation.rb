class AddGroupIdsToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :group_ids, :integer, array: true
  end
end
