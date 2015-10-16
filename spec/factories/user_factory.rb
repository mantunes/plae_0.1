require 'faker'

FactoryGirl.define do
  factory :user do
    first_name  Faker::Name.first_name
    last_name  "Doe"
    email "a@a.com"
    password "Awesome!"
  end
end
