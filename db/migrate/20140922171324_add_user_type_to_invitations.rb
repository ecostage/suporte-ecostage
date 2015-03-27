class AddUserTypeToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :user_type, :integer
  end
end
