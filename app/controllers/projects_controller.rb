class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy,
                                     :join, :append, :add_to_organization]
  authority_actions update: 'edit'
  authority_actions append: 'delete'
  authority_actions add_to_organization: 'delete'
  authority_actions join: 'read'

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'The object you tried to access does not exist'
    redirect_to projects_path
  end

  def index
    @projects = current_user.projects
  end

  def show
    authorize_action_for(@project)
    @time_entries = @project.time_entries
    @users = @project.users.order('project_memberships.created_at asc')
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      ProjectMembership.create!(user_id: current_user.id, project_id: @project.id,
                                role: 'Owner')
      flash[:notice] = "You've successfully created a new project"
      redirect_to @project
    else
      flash[:notice] = "The project couldn't be saved"
      render('new')
    end
  end

  def edit
    authorize_action_for(@project)
  end

  def update
    authorize_action_for(@project)
    if @project.update_attributes(project_params)
      flash[:notice] = 'Project updated successfully'
      redirect_to @project
    else
      flash[:notice] = "Couldn't update project details"
      render('edit')
    end
  end

  def destroy
    authorize_action_for(@project)
    @project.destroy
    current_user.projects.delete(@project)
    redirect_to projects_path
  end

  def append
    authorize_action_for(@project)
    @organizations = current_user.organizations
  end

  def add_to_organization
    authorize_action_for(@project)
    organization = Organization.find_by(id: params[:organization][:organization_id])
    if organization
      organization.projects << @project
      flash[:notice] = "#{@project.name} was added to #{organization.name} organization"
      redirect_to project_path
    else
      @project.organization = nil
      @project.save
      redirect_to project_path
    end
  end

  def join
    authorize_action_for(@project)
    membership = ProjectMembership.new(user_id: current_user.id,
                                       project_id: @project.id, role: 'Member')
    if membership.save
      flash[:notice] = "You joined #{@project.name}"
      redirect_to project_path
    else
      flash[:notice] = "Couldn't join #{@project.name}"
      redirect_to project_path
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
