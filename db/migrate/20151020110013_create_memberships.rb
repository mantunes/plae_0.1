class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true
      t.string :access_level
      t.timestamps null: false
    end
  end
end
