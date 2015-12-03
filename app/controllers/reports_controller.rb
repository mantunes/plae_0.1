class ReportsController < ApplicationController
  def index
    @time_entries = current_user.time_entries.where('end_time >= ?', 1.week.ago)
    @time_entries = @time_entries.order('updated_at desc')
    @total_hours = formatted_duration(@time_entries.sum(:total_time).to_i)
  end

  def new
  end

  def create
    @start_time = Time.zone.local(*params[:start_time].sort.map(&:last).map(&:to_i))
    @end_time = Time.zone.local(*params[:end_time].sort.map(&:last).map(&:to_i))
    @time_entries = get_entries(params[:projects], @start_time, @end_time)
    @time_entries = @time_entries.order('project_id')
    @total_hours = formatted_duration(@time_entries.sum(:total_time).to_i)
  end

  private

  def formatted_duration(total_seconds)
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60
    "#{hours} h #{minutes} m #{seconds} s"
  end

  def get_entries(projects, start_time, end_time)
    if projects.nil?
      return current_user.time_entries.where('end_time >= ? AND end_time <= ?',
                                             start_time, end_time)
    else
      time_entries = TimeEntry.where(project_id: projects)
      return time_entries.where('end_time >= ? AND end_time <= ?',
                                  start_time, end_time)
    end
  end
end
