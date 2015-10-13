class TimeEntriesController < ApplicationController
	before_action :set_time_entry, only: [:show, :edit, :update, :destroy]

	def index
		@time_entries = TimeEntry.sorted
	end

	def show
	end

	def new
		@time_entry = TimeEntry.new(name: "default", start_time: Time.now)
	end

	def create
		@time_entry = TimeEntry.new(time_entry_params)
		if @time_entry.save
			redirect_to time_entries_path
		else
			redirect_to new_time_entry_path
		end
	end

	def edit
	end

	def update
		if  @time_entry.update_attributes(time_entry_params)
			redirect_to time_entry_path(@time_entry.id)
		else
			render('edit') 
		end
	end

	def destroy
		@time_entry.destroy
		redirect_to time_entries_path
	end

	private 

	def set_time_entry
		@time_entry = TimeEntry.find(params[:id])
	end

	def time_entry_params
		params.require(:time_entry).permit(:name,:start_time,:end_time,:total_time)
	end 
end
