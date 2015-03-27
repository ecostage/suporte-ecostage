class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :subject
      t.text :content
      t.boolean :is_priority
      t.references :created_by, index: true
      t.integer :estimated_time
      t.references :assign_to, index: true
      t.string :status
      t.integer :complexity
      t.datetime :resolved_at
      t.datetime :attended_at

      t.timestamps
    end
  end
end
