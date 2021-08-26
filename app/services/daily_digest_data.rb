module Services
  class DailyDigestData < ApplicationService
    CACHE_KEY = 'daily_digest_data'.freeze

    def call
      Rails.cache.fetch(CACHE_KEY, expires_in: cache_expires_in) do
        questions.map { |q| { id: q.id, title: q.title } }
      end
    end

    private

    def questions
      Question.where('created_at >= ? AND created_at <= ?', yesterday.beginning_of_day, yesterday.end_of_day)
    end

    def yesterday
      @yesterday ||= Date.yesterday
    end

    def cache_expires_in
      Date.today.end_of_day
    end
  end
end
