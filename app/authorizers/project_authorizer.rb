class ProjectAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    members = resource.project_memberships.map(&:user_id)
    return true if members.include? user.id
    organization = resource.organization
    return true if user.organizations.include?(organization)
  end

  def updatable_by?(user)
    user_in_project = resource.project_memberships.find_by(user_id: user.id)
    return false unless user_in_project
    user_in_project.role == 'Owner'
  end

  def deletable_by?(user)
    user_in_project = resource.project_memberships.find_by(user_id: user.id)
    return false unless user_in_project
    user_in_project.role == 'Owner'
  end
end
