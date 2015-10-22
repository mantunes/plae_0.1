class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :email_invitation, :owner?]
  before_action :authenticate_user!
  helper_method :owner?

  def index
    @projects = current_user.projects
  end

  def show
    authorize_action_for(@project)
    @time_entries = @project.time_entries
    @users = @project.users
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if current_user.save
      set_user_role(current_user, @project, "Owner")
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

  def invite_members
  end

  def email_invitation
    user = User.find_by(email: params[:email].downcase)
    if user
      if Membership.find_by(user_id: user.id, project_id: @project.id )
        flash[:notice] = "User already in this project"
        render('invite_members')
      else
        user.projects << @project
        set_user_role(user, @project, params[:access_level])
        flash[:notice] = "User #{user.first_name} #{user.last_name} was added to the project"
        redirect_to projects_path
      end
    else
      flash[:notice] = "Couldn't find user with email #{params[:email]}"
      render('invite_members')
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def set_user_role user, project, role
    membership = user.memberships.find_by(project_id: project.id)
    membership.access_level = role
    membership.save
  end

  def owner? project
    project.memberships.find_by(user_id: current_user).access_level == "Owner"
  end

end
