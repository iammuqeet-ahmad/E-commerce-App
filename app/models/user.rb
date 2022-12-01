# frozen_string_literal: true

# This is user model
class User < ApplicationRecord
  include Validatable
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :products, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  has_many :comments, dependent: :destroy
end
