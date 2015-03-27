class ChangeStatusFieldOfTicket < ActiveRecord::Migration
  def change
    change_column :tickets, :status, 'integer USING CAST(status AS integer)', default: 0
  end
end
