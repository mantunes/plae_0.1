class TimeEntriesController < ApplicationController
	def index
		@time_entries = TimeEntry.sorted
	end
end
