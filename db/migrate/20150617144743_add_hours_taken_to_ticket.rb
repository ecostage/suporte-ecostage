class AddHoursTakenToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :hours_taken, :integer
  end
end
