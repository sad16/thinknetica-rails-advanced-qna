class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_one :question_with_best_answer, class_name: 'Question', foreign_key: :best_answer_id, dependent: :nullify

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :bests, -> { where(question: Question.with_best_answer) }

  def mark_as_best
    question.update(best_answer_id: id)
  end

  def best?
    question.best_answer_id == id
  end
end
