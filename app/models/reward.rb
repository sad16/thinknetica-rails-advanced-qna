class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :name, :image, presence: true

  def assign
    update(user: question.best_answer&.user)
  end

  def unassign
    update(user: nil)
  end
end
