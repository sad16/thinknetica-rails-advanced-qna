FactoryBot.define do
  factory :authorization do
    provider { 'github' }
    sequence(:uid) { |n| n.to_s }

    trait :vkontakte do
      provider { 'vkontakte' }
    end

    trait :with_confirmation_email do
      sequence(:email) { |n| "test_user_#{n}@test.com" }
      email_confirmation_at { 5.minutes.ago }
    end

    trait :with_enter_email_token do
      sequence(:enter_email_token) { |n| "enter_email_token_#{n}" }
      enter_email_token_expires_at { 5.minutes.since }
    end

    trait :with_confirm_email_token do
      sequence(:email) { |n| "test_user_#{n}@test.com" }
      sequence(:confirm_email_token) { |n| "confirm_email_token_#{n}" }
      confirm_email_token_expires_at { 1.hour.since }
    end
  end
end
