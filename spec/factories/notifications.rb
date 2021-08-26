FactoryBot.define do
  factory :notification do
    association :user
    association :question
  end
end
