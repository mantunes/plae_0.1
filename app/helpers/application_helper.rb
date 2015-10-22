module ApplicationHelper
    def formatted_time total_seconds
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60
    if hours == 0 && minutes == 0
      return "#{ seconds } s"
    elsif hours == 0 
      return "#{ minutes } m #{ seconds } s"
    else
      return "#{ hours } h #{ minutes } m #{ seconds } s"
    end
  end
end
