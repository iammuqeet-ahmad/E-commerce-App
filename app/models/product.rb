class Product < ApplicationRecord
  paginates_per 3
  belongs_to :user
  has_many_attached :photos, dependent: :destroy


  validates :name, presence: true, length: {minimum:3, maximum:50}
  validates :description, presence: true, length: {minimum:10, maximum:500}
  validates :price, presence: true, numericality: true
end
