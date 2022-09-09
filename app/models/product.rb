class Product < ApplicationRecord
  belongs_to :user
  has_many :images, as: :imageable

  validates :user_id, presence: true
end
