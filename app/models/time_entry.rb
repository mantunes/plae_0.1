class TimeEntry < ActiveRecord::Base
  include Authority::Abilities
  belongs_to :user
  belongs_to :project

  validates :name, presence: true
  validates :start_time, presence: true
  validate :end_time_is_after_start_time, if: 'end_time.present?'

  after_save :update_total_time, if: 'end_time.present?'
  after_save :update_project
  after_destroy :update_project

  paginates_per 10

  scope :recent, -> { where('end_time >= ?', Time.zone.now - 1.week) }
  scope :name_search, -> name { where('name ILIKE ?', "%#{name}%") }
  scope :time_period, lambda { |start_date, end_date|
                        where('end_time >= ? AND end_time <= ?', start_date, end_date)
                      }

  private

  def end_time_is_after_start_time
    errors.add(:end_time, 'older than start_time') unless end_time > start_time
  end

  def update_total_time
    total_seconds = end_time - start_time
    update_column(:total_time, total_seconds.floor)
  end

  def update_project
    project.save unless project.blank?
  end

end
