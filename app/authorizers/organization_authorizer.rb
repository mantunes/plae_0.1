class OrganizationAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    members = resource.organization_memberships.map(&:user_id)
    members.include? user.id
  end

  def updatable_by?(user)
    members = resource.organization_memberships.map(&:user_id)
    members.include? user.id
  end
end
