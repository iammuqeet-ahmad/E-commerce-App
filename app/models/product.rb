# frozen_string_literal: true

# This is product model
class Product < ApplicationRecord
  include Validatable

  require 'securerandom'

  before_create :set_values
  belongs_to :user

  has_many_attached :photos
  has_many :comments, dependent: :destroy

  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :serialNo, uniqueness: true

  private

  def set_values
    self.quantity = 1
    self.serialNo = SecureRandom.alphanumeric(5)
  end
end
