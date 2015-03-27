class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :notifiable, polymorphic: true, index: true
      t.references :created_by, index: true
      t.string :action

      t.timestamps
    end
  end
end
