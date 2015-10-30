class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.belongs_to :user, index: true
      t.belongs_to :organization, index: true
      t.string :role
      t.timestamps null: false
    end
  end
end
