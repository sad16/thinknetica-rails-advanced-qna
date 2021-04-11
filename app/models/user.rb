class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  def author_of?(resource)
    resource.user_id == id
  end

  def best_answers
    answers.bests
  end

  def rewards
    Reward.by_user(self)
  end
end
