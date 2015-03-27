class CreateGroupChannels < ActiveRecord::Migration
  def change
    create_table :group_channels do |t|
      t.references :channel, index: true
      t.references :group, index: true

      t.timestamps
    end
  end
end
