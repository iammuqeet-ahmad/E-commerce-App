class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end

  end
  def create?
    user.id != record.user_id
  end
  
  def destroy?
    user.id == record.user_id
  end

end
