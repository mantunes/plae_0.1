class TimeEntriesController < ApplicationController
	def index
		@time_entries = TimeEntry.sorted
	end

	def show
		@time_entry = TimeEntry.find(params[:id])
	end

	def new
		@time_entry = TimeEntry.new(name: "default", start_time: Time.now)
	end

	def create
		@time_entry = TimeEntry.new(time_entry_params)
		if @time_entry.save
			flash[:notice] = "Time Entry Created successfully"
			redirect_to(action: 'index')
		else
			render('new') 
		end
	end

private 
  def time_entry_params
    params.require(:time_entry).permit(:name,:start_time,:end_time,:total_time)
  end 
end
