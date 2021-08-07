module Services
  module Answers
    class MarkAsBest < ApplicationService
      class Error < StandardError; end
      class UserNotAuthorError < Error; end

      def call(user, answer)
        raise UserNotAuthorError unless user.author_of?(answer.question)

        ActiveRecord::Base.transaction do
          answer.mark_as_best
          answer.assign_reward
        end
      end
    end
  end
end
