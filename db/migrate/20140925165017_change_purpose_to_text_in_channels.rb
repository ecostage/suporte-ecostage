class ChangePurposeToTextInChannels < ActiveRecord::Migration
  def change
    change_column :channels, :purpose, :text
  end
end
