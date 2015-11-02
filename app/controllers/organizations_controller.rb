class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy,
                                          :email_invitation]
  before_action :set_roles, only: [:invite, :email_invitation]
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'The object you tried to access does not exist'
    redirect_to organizations_path
  end

  def index
    @organizations = current_user.organizations
  end

  def show
    authorize_action_for(@organization)
    @projects = @organization.projects
    @users = @organization.users.order('teams.created_at asc')
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = current_user.organizations.build(organization_params)
    if @organization.save
      Team.create!(user_id: current_user.id, organization_id: @organization.id,
                   role: 'Admin')
      flash[:notice] = "You've successfully created a new organization"
      redirect_to @organization
    else
      flash[:notice] = "The organization couldn't be saved"
      render('new')
    end
  end

  def edit
    authorize_action_for(@organization)
  end

  def update
    if @organization.update_attributes(organization_params)
      flash[:notice] = 'Organization updated successfully'
      redirect_to @organization
    else
      flash[:notice] = "Couldn't update organization details"
      render('edit')
    end
  end

  def destroy
    @organization.destroy
    current_user.organizations.delete(@organization)
    redirect_to organizations_path
  end

  def invite
  end

  def email_invitation
    user = User.find_by(email: params[:email].downcase)
    if user
      if Team.find_by(user_id: user.id, organization_id: @organization.id)
        flash[:notice] = 'User already in this organization'
        render('invite')
      else
        Team.create!(user_id: user.id, organization_id: @organization.id,
                     role: params[:role])
        flash[:notice] = "User #{user.first_name} #{user.last_name}
          was added to the organization"
        redirect_to organization_path
      end
    else
      flash[:notice] = "Couldn't find user with email #{params[:email]}"
      render('invite')
    end
  end

  private

  def set_roles
    @roles = Organization.roles.map(&:to_s)
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :website)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
