FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "Link #{n} name" }
    url { 'http://test.com'}
    association :linkable, factory: :question

    trait :answer_link do
      association :linkable, factory: :answer
    end

    trait :gist do
      url { 'https://gist.github.com/sad16/2f0fdb94eabdfff07781724a77067a1b' }
    end
  end
end
