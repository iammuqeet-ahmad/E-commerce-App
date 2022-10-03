# frozen_string_literal: true

class Coupon < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 4, maximum: 10 }
  validates :expiry_date, presence: true
  validates :discount, presence: true
end
