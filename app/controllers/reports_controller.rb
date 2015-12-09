class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @start_time = 7.days.ago
    @end_time = Time.now
    @time_entries = current_user.time_entries.where('end_time >= ?', 1.week.ago)
    @organizations = current_user.organizations
  end

  def create
    @start_time = Time.zone.local(*params[:start_date].sort.map(&:last).map(&:to_i))
    @end_time = Time.zone.local(*params[:end_date].sort.map(&:last).map(&:to_i))
    @time_entries = get_time_entries(params[:projects], params[:users], params[:without_project])
    @time_entries = @time_entries.where('end_time >= ? AND end_time <= ?',
                                        @start_time, @end_time)
    unless params[:name].nil?
      @time_entries = @time_entries.where('name ILIKE ?', "%#{params[:name]}%")
    end
  end

  private

  def get_time_entries(projects, users, without_project)
    if without_project == '1'
      get_user_entries(users)
    else
      get_project_entries(projects, users)
    end
  end

  def get_user_entries(users)
    if users.present?
      TimeEntry.where(user_id: users, project_id: nil)
    else
      current_user.time_entries.where(project_id: nil)
    end
  end

  def get_project_entries(projects, users)
    if projects.present? && users.nil?
      TimeEntry.where(project_id: projects)
    elsif projects.nil? && users.present?
      projects = current_user.projects.map(&:id)
      TimeEntry.where(user_id: users, project_id: projects)
    elsif projects.present? && users.present?
      TimeEntry.where(project_id: projects, user_id: users)
    else
      current_user.time_entries
    end
  end
end
