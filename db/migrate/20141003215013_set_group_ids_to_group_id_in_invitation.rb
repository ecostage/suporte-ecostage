class SetGroupIdsToGroupIdInInvitation < ActiveRecord::Migration
  def change
    rename_column :invitations, :group_ids, :group_id
    change_column :invitations, :group_id, 'integer USING CAST(group_id[0] AS integer)'
  end
end
