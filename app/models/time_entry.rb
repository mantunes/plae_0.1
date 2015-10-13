class TimeEntry < ActiveRecord::Base
		scope :sorted, lambda { order("time_entries.id ASC") } #ou position apenas
end
