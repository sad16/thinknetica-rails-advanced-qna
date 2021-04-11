class Reward < ApplicationRecord
  belongs_to :question

  has_one_attached :image

  validates :name, :image, presence: true

  scope :by_user, -> (user) { where(question: Question.where(best_answer_id: user.best_answers)) }
end
