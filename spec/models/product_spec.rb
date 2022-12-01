# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'
RSpec.describe Product, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { should have_many_attached(:photos) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(50) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_least(10).is_at_most(500) }
    it { is_expected.to validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(1) }
    it { is_expected.to validate_presence_of(:description) }
    it { should validate_uniqueness_of(:serialNo) }
  end
end
