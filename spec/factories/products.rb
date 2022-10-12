# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :product do
    name { 'Boost Shoes' }
    description { Faker::Lorem.sentence(word_count: 10) }
    price { Faker::Number.non_zero_digit }
    quantity { Faker::Number.digit }
    serialNo { Faker::Alphanumeric.alpha(number: 5) }
    photos { Rack::Test::UploadedFile.new('spec/images/BoostShoes.jpg', 'image/jpg') }
  end
end
