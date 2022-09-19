class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def update?
      if current_user.id == @product.user_id
        return true
      else
        return false
    end
  end
end
