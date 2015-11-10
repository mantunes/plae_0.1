require 'faker'

FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email
    password 'Awesome!'
    confirmed_at Time.zone.today
  end
end
