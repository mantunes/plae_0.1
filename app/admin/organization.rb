ActiveAdmin.register Organization do
  permit_params :name, :description, :website,
                organization_memberships_attributes: [:id, :project_id,
                                                      :user_id, :role, :_destroy]

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :website
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :description
  filter :website
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Organization Details' do
      f.input :name
      f.input :description
      f.input :website
      f.has_many :organization_memberships, heading: 'Organization Members',
                 allow_destroy: true do |p|
        p.input :user
        p.input :role, as: :select, collection: Organization.roles.unshift('AdminOwner')
      end
    end
    f.actions
  end

  sidebar 'Organization Information', only: [:show, :edit] do
    attributes_table do
      row :name
      row :description
      row :website
      row :created_at
      row :updated_at
    end
  end

  show do

    panel 'Users in Organization' do
      table_for organization.organization_memberships do
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

    panel 'Projects' do
      table_for organization.projects do
        column 'id' do |project|
          link_to project.id, admin_project_path(project.id)
        end
        column :name
        column 'Duration', :total_duration
      end
    end
  end
end
