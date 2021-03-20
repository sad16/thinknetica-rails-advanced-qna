class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  def mark_as_best
    question.update(best_answer_id: id)
  end

  def clear_best_mark
    question.update(best_answer_id: nil) if best?
  end

  def best?
    question.best_answer_id == id
  end
end
