FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question #{n} title" }
    sequence(:body) { |n| "Question #{n} body" }

    association :user, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_answer do
      after :create do |question|
        create :answer, question: question
      end
    end

    trait :with_answers do
      after :create do |question|
        create_list :answer, 3, question: question
      end
    end

    trait :with_best_answer do
      after :create do |question|
        create :answer, :best, question: question
      end
    end

    trait :with_link do
      after :create do |question|
        create :link, linkable: question
      end
    end

    trait :with_file do
      files { Rack::Test::UploadedFile.new("spec/fixtures/files/image_test_file.jpeg", "image/jpeg") }
    end

    trait :with_reward do
      after :create do |question|
        create :reward, question: question
      end
    end

    factory :question_with_answer_and_best_answer, traits: [:with_answer, :with_best_answer]
  end
end
