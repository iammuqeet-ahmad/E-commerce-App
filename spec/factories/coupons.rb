# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :coupon do
    name { '1PAKARMY' }
    expiry_date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    discount { Faker::Number.between(from: 0.0, to: 1.0) }
  end
end
