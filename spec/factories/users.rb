# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Muqeet' }
    email { Faker::Internet.email }
    password { '123456' }
    avatar { Rack::Test::UploadedFile.new('spec/images/ava2.png', 'image/png') }
  end
end
