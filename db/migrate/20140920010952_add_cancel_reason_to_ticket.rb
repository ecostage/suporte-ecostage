class AddCancelReasonToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :cancel_reason, :string
  end
end
