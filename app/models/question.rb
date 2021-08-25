class Question < ApplicationRecord
  include Linkable
  include Voteable
  include Commentable

  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', dependent: :destroy, optional: true

  has_one :reward, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :subscribed_users, through: :notifications, source: :user

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :with_best_answer, -> { where.not(best_answer_id: nil) }

  after_create_commit :create_notification

  def answers_without_best
    answers.where.not(id: best_answer_id)
  end

  private

  def create_notification
    notifications.create(user_id: user_id)
  end
end
