class ProjectMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:new, :create, :edit, :update,
                                     :destroy, :leave]
  before_action :set_roles, only: [:new, :create, :edit, :update]
  before_action :set_project_membership, except: :index
  authority_actions create: 'new'
  authority_actions update: 'edit'

  rescue_from ActiveRecord::RecordInvalid  do
    flash[:notice] = 'User already in this project'
    render('new')
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'The object you tried to access does not exist'
    redirect_to projects_path
  end

  def index
    redirect_to projects_path
  end

  def new
    authorize_action_for(@project_membership)
  end

  def create
    email = params[:email].downcase
    if valid_email?(email)
      user = User.find_by(email: email)
      if user
        ProjectMembership.create!(user_id: user.id, project_id: @project.id,
                                  role: params[:project_membership][:role])
        flash[:notice] = "User #{user.first_name} #{user.last_name}
        was added to the project"
        redirect_to project_path(@project.id)
      else
        flash[:notice] = 'No registered user by that name. Send him an invite'
        redirect_to new_user_invitation_path(project_id: @project.id, email: email)
      end
    else
      flash[:notice] = 'Invalid Email'
      render('new')
    end
  end

  def edit
    authorize_action_for(@project_membership)
    id = @project.project_memberships.find_by(role: 'Owner').user_id
    @users = @project.users.reject { |u| u.id == id }
  end

  def update
    user = User.find_by(id: params[:user][:id])
    set_user_role(user, @project, params[:role])
    flash[:notice] = "#{user.first_name} #{user.last_name}'s access level
      has changed"
    redirect_to project_path
  end

  def destroy
    authorize_action_for(@project_membership)
    user = User.find_by(id: params[:user_id])
    delete_user_entries(user, @project)
    flash[:notice] = "#{user.first_name} #{user.last_name}'s has
      removed from the project"
    redirect_to project_path
  end

  def leave
    authorize_action_for(@project_membership)
    delete_user_entries(current_user, @project)
    flash[:notice] = "You left #{@project.name}"
    redirect_to projects_path
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_roles
    @roles = Project.roles.map(&:to_s)
  end

  def set_user_role(user, project, role)
    membership = user.project_memberships.find_by(project_id: project.id)
    membership.role = role
    membership.save
  end

  def delete_user_entries(user, project)
    project.users.delete(user)
    member_entries = project.time_entries.where(user_id: user.id)
    project.time_entries.delete(member_entries)
  end

  def set_project_membership
    @project_membership = @project.project_memberships.build
  end

  def valid_email?(email)
    valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    email.present? && (email =~ valid_email_regex)
  end
end
