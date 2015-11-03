class ProjectAuthorizer < ApplicationAuthorizer
  def creatable_by?(user)
    user_in_project = resource.project_memberships.find_by(user_id: user.id)
    return false unless user_in_project
    user_in_project.role == 'Owner'
  end

  def readable_by?(user)
    members = resource.project_memberships.map(&:user_id)
    return true if members.include? user.id
    organization = resource.organization
    return true if user.organizations.include?(organization)
  end

  def editable_by?(user)
    user_in_project = resource.project_memberships.find_by(user_id: user.id)
    return false unless user_in_project
    user_in_project.role == 'Owner'
  end

  def appendable_by?(user)
    user_in_project = resource.project_memberships.find_by(user_id: user.id)
    return false unless user_in_project
    user_in_project.role == 'Owner'
  end
end
