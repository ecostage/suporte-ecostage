class AddChannelIdToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :channel_id, :integer
    add_index :tickets, :channel_id
  end
end
