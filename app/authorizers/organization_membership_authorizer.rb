class OrganizationMembershipAuthorizer < ApplicationAuthorizer
  def creatable_by?(user)
    user_in_organization = OrganizationMembership.find_by(user_id: user.id,
                                                          organization_id: resource.organization_id)
    return false unless user_in_organization
    role = user_in_organization.role 
    return true if role == 'AdminOwner' || role == 'Admin'
  end

  def updatable_by?(user)
    user_in_organization = OrganizationMembership.find_by(user_id: user.id,
                                                          organization_id: resource.organization_id)
    return false unless user_in_organization
    role = user_in_organization.role 
    return true if role == 'AdminOwner' || role == 'Admin'
  end

  def deletable_by?(user)
    user_in_organization = OrganizationMembership.find_by(user_id: user.id,
                                                          organization_id: resource.organization_id)
    return false unless user_in_organization
    role = user_in_organization.role 
    return true if role == 'AdminOwner' || role == 'Admin'
  end

  def leavable_by?(user)
    user_in_organization = OrganizationMembership.find_by(user_id: user.id,
                                                          organization_id: resource.organization_id)
    return false unless user_in_organization
    role = user_in_organization.role 
    return true unless role == 'AdminOwner'
  end
end
