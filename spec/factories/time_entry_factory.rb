require 'faker'

FactoryGirl.define do
  factory :time_entry do
    name Faker::Name.name
    start_time Time.zone.now
    end_time Time.zone.now + 1
  end
end
