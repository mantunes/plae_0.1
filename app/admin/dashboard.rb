ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do

    columns do

      column do
        panel 'Recent Users' do
          table_for User.order('created_at desc').limit(10).each do
            column 'name' do |user|
              "#{user.first_name} #{user.last_name}"
            end
            column(:email) { |user| link_to(user.email, admin_user_path(user)) }
          end
        end
      end

      column do
        panel 'Recent Time Entries' do
          table_for TimeEntry.order('created_at desc').limit(10).each do
            column(:name) { |entry| link_to(entry.name, admin_time_entry_path(entry)) }
            column(:user) { |entry| link_to(entry.user.email, admin_user_path(entry.user)) }
            column 'Total time', &:total_time
          end
        end
      end

    end

    columns do

      column do
        panel 'Recent Projects' do
          table_for Project.last(5).map do
            column(:name) do |project|
              link_to(project.name, admin_project_path(project))
            end
            column 'Duration', &:total_duration
            column(:users) { |project| project.project_memberships.count }
          end
        end
      end

      column do
        panel 'Recent Organizations' do
          table_for Organization.order('created_at desc').limit(10).each do
            column(:name) do |organization|
              link_to(organization.name, admin_organization_path(organization))
            end
            column 'Website', &:website
            column(:users) { |organization| organization.organization_memberships.count }
          end
        end
      end
    end

  end
end
