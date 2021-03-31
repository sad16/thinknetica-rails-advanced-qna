FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question #{n} title" }
    sequence(:body) { |n| "Question #{n} body" }

    association :user, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_best_answer do
      after :create do |question|
        create_list :answer, 3, question: question
        question.answers.last.mark_as_best
      end
    end

    trait :with_file do
      files { Rack::Test::UploadedFile.new("spec/fixtures/files/image_test_file.jpeg", "image/jpeg") }
    end

  end
end
