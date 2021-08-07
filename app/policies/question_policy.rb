class QuestionPolicy < ApplicationPolicy
  def update?
    author_of?
  end

  def destroy?
    author_of?
  end
end
