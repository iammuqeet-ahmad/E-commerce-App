# frozen_string_literal: true

# This is product policies
class ProductPolicy < ApplicationPolicy
  # This is scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
  end

  def update?
    user.id == record.user_id
  end

  def edit?
    user.id == record.user_id
  end

  def destroy?
    user.id == record.user_id
  end
  # %i[update? edit? destroy?].each do |action|
  #   define_method action do
  #     user.id == @product.user_id
  #   end
  # end
end
