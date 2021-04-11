FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }

    association :user, factory: :user
    association :question, factory: :question

    trait :invalid do
      body { nil }
    end

    trait :best do
      after :create do |answer|
        answer.mark_as_best
      end
    end

    trait :with_link do
      after :create do |answer|
        create :link, linkable: answer
      end
    end

    trait :with_file do
      files { Rack::Test::UploadedFile.new("spec/fixtures/files/image_test_file.jpeg", "image/jpeg") }
    end
  end
end
