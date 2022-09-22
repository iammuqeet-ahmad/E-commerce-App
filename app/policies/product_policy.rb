class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    # def new?
    #   if current_user.id == @product.user_id
    #     return true
    #   else
    #     return false
    #   end
    # end

    def update?
      user.id == @product.user_id
    end

    def edit?
      user.id == @product.user_id
    end

    def destroy?
      user.id == @product.user_id
    end 



    # %i[update? edit? destroy?].each do |action|
    #   define_method action do
    #     user.id == @product.user_id
    #   end
    # end
  end
end
