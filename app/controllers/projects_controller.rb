class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @projects = current_user.projects
  end

  def show
    authorize_action_for(@project)
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if current_user.save
      set_manager_role(current_user, @project)
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
   if @project.update_attributes(project_params)
    flash[:notice] = "Project updated successfully"
    redirect_to @project
  else
    flash[:notice] = "Couldn't update project details"
    render('edit')
  end
end

def destroy
 @project.destroy
 current_user.projects.delete(@project)
 redirect_to projects_path
end

private

def project_params
  params.require(:project).permit(:name)
end

def set_project
  @project = Project.find(params[:id])
end

def set_manager_role user, project
  membership = user.memberships.find_by(project_id: project.id)
  membership.access_level = "Manager"
  membership.save
end

end
