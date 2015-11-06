class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :organization_id, index: true
      t.string :name
      t.integer :total_duration, limit: 8
      t.timestamps null: false
    end
  end
end
