class ProjectMembershipsController < ApplicationController
  before_action :set_project, only: [:new, :create, :edit, :update]
  before_action :set_roles, only: [:new, :create, :edit, :update]
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'The object you tried to access does not exist'
    redirect_to projects_path
  end

  def index 
    redirect_to projects_path
  end

  def new
    authorize_action_for(@project)
  end

  def create
    authorize_action_for(@project)
    user = User.find_by(email: params[:email].downcase)
    if user
      if ProjectMembership.find_by(user_id: user.id, project_id: @project.id)
        flash[:notice] = 'User already in this project'
        render('new')
      else
        ProjectMembership.create!(user_id: user.id, project_id: @project.id,
                                  role: params[:role])
        flash[:notice] = "User #{user.first_name} #{user.last_name}
        was added to the project"
        redirect_to projects_path
      end
    else
      flash[:notice] = "Couldn't find user with email #{params[:email]}"
      render('new')
    end
  end

  def edit
    #authorize_action_for(@project)
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
end
