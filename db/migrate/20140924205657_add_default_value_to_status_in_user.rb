class AddDefaultValueToStatusInUser < ActiveRecord::Migration
  def change
    change_column :users, :status, :integer, default: 0
  end
end
