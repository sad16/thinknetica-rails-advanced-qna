class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    Services::SendDailyDigest.new.call
  end
end
