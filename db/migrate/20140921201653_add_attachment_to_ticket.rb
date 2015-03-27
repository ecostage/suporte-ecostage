class AddAttachmentToTicket < ActiveRecord::Migration
  def self.up
    add_attachment :tickets, :attachment
  end

  def self.down
    remove_attachment :tickets, :attachment
  end
end
