class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :total_duration, limit: 8
      t.timestamps null: false
    end
  end
end
