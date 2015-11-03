class OrganizationAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    members = resource.organization_memberships.map(&:user_id)
    members.include? user.id
    true
  end

  def editable_by?(user)
    user_in_organization = resource.organization_memberships.find_by(user_id: user.id)
    return false unless user_in_organization
    user_in_organization.role == 'Admin'
  end

  def creatable_by?(user)
    user_in_organization = resource.organization_memberships.find_by(user_id: user.id)
    return false unless user_in_organization
    user_in_organization.role == 'Admin'
  end
end
