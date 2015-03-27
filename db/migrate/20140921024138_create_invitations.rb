class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.references :sender, index: true

      t.timestamps
    end
  end
end
