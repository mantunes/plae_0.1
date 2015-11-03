class CreateProjectMemberships < ActiveRecord::Migration
  def change
    create_table :project_memberships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true
      t.string :role
      t.timestamps null: false
    end
  end
end
