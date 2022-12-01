# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence(word_count: 5) }
  end
end
