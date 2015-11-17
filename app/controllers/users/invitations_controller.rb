class Users::InvitationsController < Devise::InvitationsController

  def create
    super do |_|
      unless params[:project_id].blank?
        ProjectMembership.create(user_id: resource.id,
                                 project_id: params[:project_id], role: 'Member')
      end
      unless params[:organization_id].blank?
        OrganizationMembership.create(user_id: resource.id,
                                      organization_id: params[:organization_id],
                                      role: 'Normal')
      end
    end
  end

  private

  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |u|
      u.skip_invitation = false
    end
  end

  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    # Analytics.report('invite.accept', resource.id)
    resource
  end
end
