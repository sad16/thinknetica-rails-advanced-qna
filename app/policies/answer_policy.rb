class AnswerPolicy < ApplicationPolicy
  def update?
    author_of?
  end

  def destroy?
    author_of?
  end

  def mark_as_best?
    author_of?(record.question)
  end
end
