class OrganizationMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:new, :create, :edit, :update,
                                          :destroy, :leave]
  before_action :set_roles, only: [:new, :create, :edit, :update]
  before_action :set_organization_membership, except: :index
  authority_actions create: 'new'
  authority_actions update: 'edit'


  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'The object you tried to access does not exist'
    redirect_to organizations_path
  end

  def index
    redirect_to organizations_path
  end

  def new
    authorize_action_for(@organization_membership)
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user
      if OrganizationMembership.find_by(user_id: user.id, organization_id: @organization.id)
        flash[:notice] = 'User already in this organization'
        render('new')
      else
        OrganizationMembership.create!(user_id: user.id, organization_id: @organization.id,
                                       role: params[:role])
        flash[:notice] = "User #{user.first_name} #{user.last_name}
          was added to the organization"
        redirect_to organization_path(@organization.id)
      end
    else
      flash[:notice] = "Couldn't find user with email #{params[:email]}"
      render('new')
    end
  end

  def edit
    authorize_action_for(@organization_membership)
    id = @organization.organization_memberships.find_by(role: 'AdminOwner').user_id
    @users = @organization.users.reject { |u| u.id == id }
  end

  def update
    user = User.find_by(id: params[:user][:id])
    set_user_role(user, @organization, params[:role])
    flash[:notice] = "#{user.first_name} #{user.last_name}'s access level
      has changed"
    redirect_to organization_path
  end

  def destroy
    authorize_action_for(@organization_membership)
    user = User.find_by(id: params[:user_id])
    delete_user_organization(user, @organization)
    flash[:notice] = "#{user.first_name} #{user.last_name}'s has
      removed from the project"
    redirect_to organization_path
  end

  def leave
    delete_user_organization(current_user, @organization)
    flash[:notice] = "You left #{@organization.name}"
    redirect_to organizations_path
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_roles
    @roles = Organization.roles.map(&:to_s)
  end

  def set_user_role(user, organization, role)
    membership = user.organization_memberships.find_by(organization_id: organization.id)
    membership.role = role
    membership.save
  end

  def delete_user_organization(user, organization)
    organization.users.delete(user)
  end

  def set_organization_membership
    @organization_membership = @organization.organization_memberships.build
  end
end
