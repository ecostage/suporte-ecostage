class ChangePurposeToTextInGroups < ActiveRecord::Migration
  def change
    change_column :groups, :purpose, :text
  end
end
