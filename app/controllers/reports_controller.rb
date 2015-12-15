class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:start_date].blank?
      @time_entries = weekly_entries
    else
      @start_time = Time.zone.local(*params[:start_date].sort.map(&:last).map(&:to_i))
      @end_time = Time.zone.local(*params[:end_date].sort.map(&:last).map(&:to_i))
      @time_entries = get_time_entries(params[:projects], params[:users])
      @time_entries = @time_entries.time_period(@start_time, @end_time)
      @time_entries = @time_entries.name_search(params[:name])
    end
    export_to
  end

  private

  def weekly_entries
    @start_time = 7.days.ago
    @end_time = Time.zone.now
    current_user.time_entries.recent
  end

  def get_time_entries(projects, users)
    if projects.present? && projects[0] == 'Without Project'
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

  def export_to
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'project', template: 'reports/index.html.erb'
      end
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"report.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
