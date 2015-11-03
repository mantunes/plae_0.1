class ProjectAuthorizer < ApplicationAuthorizer
  def creatable_by?(user)
    user_in_project = resource.project_memberships.find_by(user_id: user.id)
    return false unless user_in_project
    user_in_project.role == 'Owner'
  end

  def readable_by?(user)
    members = resource.project_memberships.map(&:user_id)
    members.include? user.id
  end

  def editable_by?(user)
    user_in_project = resource.project_memberships.find_by(user_id: user.id)
    return false unless user_in_project
    user_in_project.role == 'Owner'
  end
end
