# frozen_string_literal: true

# This is comment policies
class CommentPolicy < ApplicationPolicy
  # This is scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
  end

  def create?
    user.id != record.user_id
  end

  def edit?
    user.id == record.user_id
  end

  def update?
    user.id == record.user_id
  end

  def destroy?
    user.id == record.user_id
  end
end
