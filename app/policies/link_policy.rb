class LinkPolicy < ApplicationPolicy
  def destroy?
    author_of?(record.linkable)
  end
end
