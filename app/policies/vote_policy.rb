class VotePolicy < ApplicationPolicy
  def show?
    record.present? && !author_of?(record.voteable)
  end

  def destroy?
    author_of?
  end
end
