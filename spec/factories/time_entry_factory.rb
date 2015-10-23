require 'faker'

FactoryGirl.define do
  factory :time_entry do
    name Faker::Name.name
    start_time Time.now
    end_time Time.now+1
  end
end
