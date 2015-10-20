class ProjectAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    members = resource.memberships.map(&:user_id)
    members.include? user.id
  end
  def updatable_by?(user)
    members = resource.memberships.map(&:user_id)
    members.include? user.id
  end
end