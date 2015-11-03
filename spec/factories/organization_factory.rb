require 'faker'

FactoryGirl.define do
  factory :organization do
    name Faker::Name.name
    description Faker::Lorem.sentence(3)
    website Faker::Internet.url
  end
end
