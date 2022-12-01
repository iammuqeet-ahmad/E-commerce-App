# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:products).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { should have_one_attached(:avatar) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:name).is_at_least(3) }
  end
end
