class TimeEntry < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :user
  belongs_to :project
  
  validates :name, presence: true
  validates :start_time, presence: true

  validate :end_time_is_after_start_time

  after_save :update_total_time, :update_project
  after_destroy :update_project

  private 

  def end_time_is_after_start_time
    if end_time <= start_time
      errors.add(:end_time, "cannot be equal or older than start time")
    end
  end

  def update_total_time
    total_seconds = end_time - start_time
    self.update_column(:total_time, total_seconds.floor)
  end

  def update_project
    self.project.save unless self.project.blank?
  end

end
