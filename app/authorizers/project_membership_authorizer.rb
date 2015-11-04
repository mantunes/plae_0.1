class ProjectMembershipAuthorizer < ApplicationAuthorizer

  def creatable_by?(user)
    user_in_project = ProjectMembership.find_by(user_id: user.id,
                                                project_id: resource.project_id)
    return false unless user_in_project
    role = user_in_project.role
    return true if role == 'Owner' || role == 'Manager'
  end

  def updatable_by?(user)
    user_in_project = ProjectMembership.find_by(user_id: user.id,
                                                project_id: resource.project_id)
    return false unless user_in_project
    role = user_in_project.role
    return true if role == 'Owner' || role == 'Manager'
  end

  def deletable_by?(user)
    user_in_project = ProjectMembership.find_by(user_id: user.id,
                                                project_id: resource.project_id)
    return false unless user_in_project
    role = user_in_project.role
    return true if role == 'Owner' || role == 'Manager'
  end

  def leavable_by?(user)
    user_in_project = ProjectMembership.find_by(user_id: user.id,
                                                project_id: resource.project_id)
    return false unless user_in_project
    role = user_in_project.role
    return true unless role == 'Owner'
  end

  def appendable_by?(user)
    user_in_project = ProjectMembership.find_by(user_id: user.id,
                                                project_id: resource.project_id)
    return false unless user_in_project
    role = user_in_project.role
    return true if role == 'Owner'
  end

end
