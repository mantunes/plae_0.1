module ProjectsHelper
  def owner?(project)
    user_in_project = project.project_memberships.find_by(user_id: current_user)
    return false unless user_in_project
    return true if user_in_project.role == 'Owner'
  end

  def already_in_project?(project)
    current_user.projects.include?(project)
  end
end
