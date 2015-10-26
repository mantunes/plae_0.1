class ProjectAuthorizer < ApplicationAuthorizer

  def readable_by?(user)
    members = resource.memberships.map(&:user_id)
    members.include? user.id
  end

  def updatable_by?(user)
    members = resource.memberships.map(&:user_id)
    members.include? user.id
  end

  def invitable_by?(user)
    user_in_project = resource.memberships.find_by(user_id: user.id)
    return false unless user_in_project
    if user_in_project.access_level == "Owner"
      return true
    else
      return false
    end
  end

end