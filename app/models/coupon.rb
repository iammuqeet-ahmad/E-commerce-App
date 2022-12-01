# frozen_string_literal: true

class Coupon < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: true }, length: { minimum: 4, maximum: 10 }
  validates :expiry_date, presence: true
  validates :discount, presence: true, numericality: { greater_than_or_equal_to: 0.1 }
end
