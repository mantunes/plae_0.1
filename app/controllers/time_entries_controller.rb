class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: [:show, :edit, :update, :destroy,
                                        :append, :add_to_project]
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'The object you tried to access does not exist'
    redirect_to time_entries_path
  end

  def index
    @time_entries = current_user.time_entries.order(updated_at: :desc)
  end

  def show
    authorize_action_for(@time_entry)
  end

  def new
    @time_entry = TimeEntry.new
  end

  def create
    @time_entry = current_user.time_entries.build(time_entry_params)
    if @time_entry.save
      flash[:notice] = "You've successfully created a new time entry"
      redirect_to @time_entry
    else
      flash[:notice] = "The time entry couldn't be saved"
      render('new')
    end
  end

  def edit
    authorize_action_for(@time_entry)
  end

  def update
    if @time_entry.update_attributes(time_entry_params)
      flash[:notice] = 'Time entry updated successfully'
      redirect_to @time_entry
    else
      flash[:notice] = "Couldn't update the time entry "
      render('edit')
    end
  end

  def destroy
    @time_entry.destroy
    redirect_to time_entries_path
  end

  def append
    authorize_action_for(@time_entry)
    @projects = current_user.projects
  end

  def add_to_project
    project = Project.find(params[:project][:project_id])
    project.time_entries << @time_entry
    flash[:notice] = "#{@time_entry.name} was added to #{project.name} project"
    redirect_to time_entries_path
  end

  private

  def set_time_entry
    @time_entry = TimeEntry.find(params[:id])
  end

  def time_entry_params
    params.require(:time_entry).permit(:name, :start_time, :end_time)
  end
end
