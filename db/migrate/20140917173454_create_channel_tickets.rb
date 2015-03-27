class CreateChannelTickets < ActiveRecord::Migration
  def change
    create_table :channel_tickets do |t|
      t.references :channel, index: true
      t.references :ticket, index: true

      t.timestamps
    end
  end
end
