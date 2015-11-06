module OrganizationsHelper
  def admin?(organization)
    organization.organization_memberships.find_by(user_id: current_user).role == 'Admin'
  end
end
