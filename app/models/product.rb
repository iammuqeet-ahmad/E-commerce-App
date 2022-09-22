class Product < ApplicationRecord
  include Validatable
  paginates_per 6
  belongs_to :user
  has_many_attached :photos
  has_many :comments, dependent: :destroy
  validates :description, presence: true, length: {minimum:10, maximum:500}
  validates :price, presence: true, numericality: true
end
