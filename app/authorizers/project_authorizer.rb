class ProjectAuthorizer < ApplicationAuthorizer
  def creatable_by?(user)
     user_in_project = resource.project_memberships.find_by(user_id: user.id)
     return false unless user_in_project
     if user_in_project.role == 'Owner'
       return true
     else
       return false
     end
  end

  def readable_by?(user)
    members = resource.project_memberships.map(&:user_id)
    members.include? user.id
  end

  def updatable_by?(user)
    members = resource.project_memberships.map(&:user_id)
    members.include? user.id
  end

  def editable_by?(user)
    user_in_project = resource.project_memberships.find_by(user_id: user.id)
    return false unless user_in_project
    if user_in_project.role == 'Owner'
      return true
    else
      return false
    end
  end
end
