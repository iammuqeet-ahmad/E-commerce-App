# frozen_string_literal: true

# This is user model
class User < ApplicationRecord
  include Validatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :products, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :avatar, dependent: :destroy
end
