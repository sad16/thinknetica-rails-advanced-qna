class Question < ApplicationRecord
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def answers_without_best
    answers.where.not(id: best_answer_id)
  end
end
