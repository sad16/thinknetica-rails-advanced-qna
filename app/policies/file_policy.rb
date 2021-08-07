class FilePolicy < ApplicationPolicy
  def destroy?
    author_of?(record.record)
  end
end
