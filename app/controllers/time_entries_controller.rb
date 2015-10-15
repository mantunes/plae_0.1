class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: [:show, :edit, :update, :destroy]
  authorize_actions_for TimeEntry, :except => [:new,:create, :show, :edit,:delete, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'The object you tried to access does not exist'
    redirect_to users_path
    end

  def index
    @time_entries = TimeEntry.sort_by_updated
  end

  def show
    authorize_action_for(@time_entry)
  end

  def new
    @time_entry = TimeEntry.new(name: "default")
  end

  def create
    @time_entry = TimeEntry.new(time_entry_params)
    if @time_entry.save
      current_user.time_entries << @time_entry
      redirect_to @time_entry
    else
      render('new')
    end
  end

  def edit
  end

  def update
    if  @time_entry.update_attributes(time_entry_params)
      redirect_to @time_entry
    else
      render('edit')
    end
  end

  def destroy
    @time_entry.destroy
    redirect_to users_path
  end

  private 

  def set_time_entry
    @time_entry = TimeEntry.find(params[:id])
  end

  def time_entry_params
    params.require(:time_entry).permit(:name,:start_time,:end_time,:total_time)
  end 
end
