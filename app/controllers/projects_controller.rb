class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :invite, 
    :email_invitation, :manage, :update_members, :remove_members, 
    :leave ,:owner?]
  before_action :set_roles, only: [:invite, :manage, :email_invitation]
  before_action :authenticate_user!
  helper_method :owner?

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
    @users = @project.users.order('memberships.created_at asc')
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      membership = Membership.new(user_id: current_user.id, project_id: @project.id)
      if membership.save
        set_user_role(current_user, @project, "Owner")
        flash[:notice] = "You've successfully created a new project"
        redirect_to @project
      end
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

  def invite
    authorize_action_for(@project)
  end

  def email_invitation
    user = User.find_by(email: params[:email].downcase)
    if user
      if Membership.find_by(user_id: user.id, project_id: @project.id )
        flash[:notice] = "User already in this project"
        render('invite')
      else
        user.projects << @project
        set_user_role(user, @project, params[:access_level])
        flash[:notice] = "User #{user.first_name} #{user.last_name}
          was added to the project"
        redirect_to projects_path
      end
    else
      flash[:notice] = "Couldn't find user with email #{params[:email]}"
      render('invite')
    end
  end

  def manage
    authorize_action_for(@project)
    id = @project.memberships.find_by(access_level: "Owner").user_id
    @users = @project.users.reject {|u| u.id == id}
  end

  def update_members
    user = User.find_by(id: params[:user][:id])
    set_user_role(user, @project, params[:access_level])
    flash[:notice] = "#{user.first_name} #{user.last_name}'s access level 
      has changed to '#{params[:access_level]}'"
    redirect_to project_path
  end

  def remove_members
    user = User.find_by(id: params[:user_id])
    @project.users.delete(user)
    member_entries = @project.time_entries.where(user_id: user.id)
    @project.time_entries.delete(member_entries)
    flash[:notice] = "#{user.first_name} #{user.last_name}'s has 
      removed from the project"
    redirect_to project_path
  end

  def leave
    @project.users.delete(current_user)
    member_entries = @project.time_entries.where(user_id: current_user.id)
    @project.time_entries.delete(member_entries)
    flash[:notice] = "You left #{@project.name}"
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def set_roles
    @roles = Project.get_roles.map(&:to_s)
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
