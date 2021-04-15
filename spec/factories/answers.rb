FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }

    association :user
    association :question

    trait :invalid do
      body { nil }
    end

    trait :best do
      after :create do |answer|
        answer.mark_as_best

        reward = answer.reward
        if reward
          reward.user_id = answer.user_id
          reward.save
        end
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
