class Tasks < ActiveRecord::Migration
  def up
    create_table :tasks do |t|
      t.integer :list_id, null: false
      t.string :name, null: false
      t.datetime :due_date
      t.boolean :completed, null: false
    end
  end

  def down
    drop_table :tasks
  end
end
