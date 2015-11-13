ActiveAdmin.register TimeEntry do
  permit_params :name, :start_time, :end_time, :total_time, :project_id, :user_id

  index do
    selectable_column
    id_column
    column :name
    column :start_time
    column :end_time
    column 'Duration', :total_time
    column :user
    column :project
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :start_time
  filter :end_time
  filter :total_time
  filter :user
  filter :project
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Time Entry Details' do
      f.input :name
      f.input :start_time
      f.input :end_time
      f.input :total_time
      f.input :user
      f.input :project
    end
    f.actions
  end

end
