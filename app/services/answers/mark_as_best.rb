module Services
  module Answers
    class MarkAsBest < ApplicationService
      class Error < StandardError; end
      class UserNotAuthorError < Error; end

      def call(user, answer)
        if user.author_of?(answer.question)
          ActiveRecord::Base.transaction do
            answer.mark_as_best
            answer.assign_reward
          end
        else
          raise UserNotAuthorError
        end
      end
    end
  end
end
