module Services
  class SendNotifications < ApplicationService
    BATCH_SIZE = 500

    def call(answer)
      answer.question.subscribed_users.find_each(batch_size: BATCH_SIZE) { |u| deliver_mail(u, answer) }
    end

    private

    def deliver_mail(user, answer)
      NotificationMailer.new_answer(user, answer).deliver_later
    end
  end
end
