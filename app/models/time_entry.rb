class TimeEntry < ActiveRecord::Base
	validates :name, presence: true

	scope :sorted, lambda { order("time_entries.id ASC") } #ou position apenas
end
