class NotificationPolicy < ApplicationPolicy
  def destroy?
    owner_of?
  end
end
