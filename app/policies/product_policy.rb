# frozen_string_literal: true

# This is product policies
class ProductPolicy < ApplicationPolicy
  # This is scope
  class Scope < Scope
  end

  def update?
    owner?
  end

  def edit?
    owner?
  end

  def destroy?
    owner?
  end
end
