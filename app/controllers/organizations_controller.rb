class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  authority_actions update: 'edit'

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'The object you tried to access does not exist'
    redirect_to organizations_path
  end

  def index
    @organizations = current_user.organizations.order(updated_at: :desc).page(params[:page])
  end

  def show
    authorize_action_for(@organization)
    @projects = @organization.projects
    @users = @organization.users.order('organization_memberships.created_at asc')
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = current_user.organizations.build(organization_params)
    if @organization.save
      OrganizationMembership.create!(user_id: current_user.id, organization_id: @organization.id,
                                     role: 'AdminOwner')
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
    authorize_action_for(@organization)
    @organization.destroy
    current_user.organizations.delete(@organization)
    redirect_to organizations_path
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :description, :website)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
