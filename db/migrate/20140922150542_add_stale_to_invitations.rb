class AddStaleToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :stale, :boolean, default: false
  end
end
