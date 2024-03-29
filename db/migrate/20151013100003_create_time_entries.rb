class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.integer :user_id, index: true
      t.integer :project_id, index: true
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.integer :total_time, limit: 8
      t.timestamps null: false
    end
  end
end
