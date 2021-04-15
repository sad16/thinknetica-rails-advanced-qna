FactoryBot.define do
  factory :reward do
    sequence(:name) { |n| "Reward #{n} name" }
    image { Rack::Test::UploadedFile.new("spec/fixtures/files/image_test_file.jpeg", "image/jpeg") }

    association :question

    trait :assigned do
      association :user
    end
  end
end
