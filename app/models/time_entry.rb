class TimeEntry < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :user

  validates :name, presence: true
  validate :end_time_cannot_be_older_than_start_time

  def end_time_cannot_be_older_than_start_time
    if end_time == start_time
      errors.add(:end_time, "can't be equal to Start time")
    end
  end

  scope :sort_by_updated, lambda { order("time_entries.updated_at DESC") }
end
