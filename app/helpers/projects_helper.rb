module ProjectsHelper
  def owner?(project)
    project.memberships.find_by(user_id: current_user).access_level == 'Owner'
  end
end
