class ProjectMembershipsController < ApplicationController
  before_action :set_project, only: [:new, :create]
  before_action :set_roles, only: [:new, :create]
  before_action :authenticate_user!

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
                                  access_level: params[:access_level])
        flash[:notice] = "User #{user.first_name} #{user.last_name}
        was added to the project"
        redirect_to projects_path
      end
    else
      flash[:notice] = "Couldn't find user with email #{params[:email]}"
      render('new')
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_roles
    @roles = Project.roles.map(&:to_s)
  end
end
