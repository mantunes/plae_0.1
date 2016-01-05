module ReportsHelper
  def formatted_duration(total_seconds)
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60
    hours.to_s + ':' + format('%02d', minutes.to_s) + ':' + format('%02d', seconds.to_s)
  end
end
