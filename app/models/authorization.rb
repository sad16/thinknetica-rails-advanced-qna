class Authorization < ApplicationRecord
  belongs_to :user, optional: true

  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: [:provider] }
end
