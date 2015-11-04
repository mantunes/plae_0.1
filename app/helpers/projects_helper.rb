module ProjectsHelper
  def already_in_project?(project)
    current_user.projects.include?(project)
  end
end
