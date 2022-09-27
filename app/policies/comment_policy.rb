# frozen_string_literal: true

# This is comment policies
class CommentPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def create?
    user.id != record.user_id
  end

  def edit?
    owner?
  end

  def update?
    owner?  
  end

  def destroy?
    owner?
  end
end
