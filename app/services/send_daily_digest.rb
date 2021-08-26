module Services
  class SendDailyDigest < ApplicationService
    BATCH_SIZE = 500

    def call
      User.find_each(batch_size: BATCH_SIZE) { |u| deliver_mail(u) } if questions_data.present?
    end

    private

    def deliver_mail(user)
      DailyDigestMailer.digest(user).deliver_later
    end

    def questions_data
      Services::DailyDigestData.new.call
    end
  end
end
