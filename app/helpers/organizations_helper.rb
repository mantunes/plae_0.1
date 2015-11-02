module OrganizationsHelper
  def admin?(organization)
    organization.teams.find_by(user_id: current_user).role == 'Admin'
  end
end
