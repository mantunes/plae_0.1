class TimeEntry < ActiveRecord::Base
	validates :name, presence: true
	validate :end_time_cannot_be_older_than_start_time, on: :update

	def end_time_cannot_be_older_than_start_time
   	 if end_time == start_time
   	   errors.add(:end_time, "can't be equal to Start time")
  	  end
  end

	scope :sorted, lambda { order("time_entries.id ASC") } #ou position apenas
end
