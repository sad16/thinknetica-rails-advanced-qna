class Question < ApplicationRecord
  include Linkable
  include Voteable

  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', dependent: :destroy, optional: true

  has_one :reward, dependent: :destroy

  has_many :answers, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :with_best_answer, -> { where.not(best_answer_id: nil) }

  def answers_without_best
    answers.where.not(id: best_answer_id)
  end
end
