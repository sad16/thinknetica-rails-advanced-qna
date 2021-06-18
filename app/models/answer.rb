class Answer < ApplicationRecord
  include Linkable
  include Voteable
  include Commentable

  belongs_to :user
  belongs_to :question

  has_one :question_with_best_answer, class_name: 'Question', foreign_key: :best_answer_id, dependent: :nullify
  has_one :reward, through: :question_with_best_answer

  has_many_attached :files

  before_destroy :unassign_reward, prepend: true

  validates :body, presence: true

  scope :bests, -> { where(question: Question.with_best_answer) }

  def mark_as_best
    question.update(best_answer_id: id)
  end

  def best?
    question.best_answer_id == id
  end

  def assign_reward
    reward&.assign
  end

  def unassign_reward
    reward&.unassign
  end
end
