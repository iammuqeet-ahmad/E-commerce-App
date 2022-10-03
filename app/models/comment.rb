# frozen_string_literal: true

# This is comment model
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :content, presence: true, length: { minimum: 3, maximum: 500 }
end
