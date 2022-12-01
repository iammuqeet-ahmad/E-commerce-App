# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(4).is_at_most(10) }
    it { is_expected.to validate_presence_of(:expiry_date) }
    it { is_expected.to validate_presence_of(:discount) }
    it { should validate_numericality_of(:discount).is_greater_than_or_equal_to(0.1) }
  end
end
