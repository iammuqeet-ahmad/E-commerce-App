# frozen_string_literal: true

# This is user policies
class UserPolicy < ApplicationPolicy
  # This is scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
