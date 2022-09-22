# frozen_string_literal: true

module Validatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, length: { minimum: 3 }
  end
end
