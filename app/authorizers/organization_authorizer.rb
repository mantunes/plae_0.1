class OrganizationAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    members = resource.organization_memberships.map(&:user_id)
    members.include? user.id
  end

  def updatable_by?(user)
    user_in_organization = resource.organization_memberships.find_by(user_id: user.id)
    return false unless user_in_organization
    user_in_organization.role == 'AdminOwner'
  end

  def deletable_by?(user)
    user_in_organization = resource.organization_memberships.find_by(user_id: user.id)
    return false unless user_in_organization
    user_in_organization.role == 'AdminOwner'
  end
end
