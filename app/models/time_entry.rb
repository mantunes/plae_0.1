class TimeEntry < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :user

  validates :name, presence: true
  validate :end_time_is_after_start_date

  def end_time_is_after_start_date
    if end_time <= start_time
      errors.add(:end_time, "cannot be equal or older than Start time")
    end
  end

  scope :sort_by_updated, lambda { order("time_entries.updated_at DESC") }
end
