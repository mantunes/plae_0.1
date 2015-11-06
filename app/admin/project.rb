ActiveAdmin.register Project do
  permit_params :name, :total_duration, :organization_id,
                project_memberships_attributes: [:id, :user_id, :role, :_destroy]

  index do
    selectable_column
    id_column
    column :name
    column 'Duration', :total_duration
    column :organization
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :total_duration
  filter :users
  filter :organization
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Project Details' do
      f.input :name
      f.input :total_duration
      f.input :organization
      f.has_many :project_memberships, heading: 'Project Members', allow_destroy: true do |p|
        p.input :user
        p.input :role, as: :select, collection: Project.roles.unshift('Owner')
      end
    end
    f.actions
  end

  sidebar 'Project Information', only: [:show, :edit] do
    attributes_table do
      row :name
      row :total_duration
      row :organization
      row :created_at
      row :updated_at
    end
  end

  show do

    panel 'Users in Project' do
      table_for project.project_memberships do
        column 'id' do |member|
          link_to member.user.id, admin_user_path(member.user.id)
        end
        column 'name' do |member|
          "#{member.user.first_name} #{member.user.last_name}"
        end
        column 'join date', :created_at
        column 'updated at', :updated_at
        column 'Role', :role
      end
    end

    panel 'Time Entries' do
      table_for project.time_entries do
        column 'id' do |time_entry|
          link_to time_entry.id, admin_time_entry_path(time_entry.id)
        end
        column :name
        column :start_time
        column :end_time
        column :total_time
        column :user
      end
    end
  end
end