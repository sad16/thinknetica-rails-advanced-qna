class NotificationsJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::SendNotifications.new.call(answer)
  end
end
