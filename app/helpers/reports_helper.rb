module ReportsHelper
  def convert_to_amcharts_json(data_array)
    data_array.to_json.gsub(/\"text\"/, "text").html_safe
  end

  def formatted_duration(total_seconds)
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60
    hours.to_s + ':' + format('%02d', minutes.to_s) + ':' + format('%02d', seconds.to_s)
  end
end
