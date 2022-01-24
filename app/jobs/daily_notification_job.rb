class DailyNotificationJob < ApplicationJob
  queue_as :default

  def perform
    NotificationSender.new.send_newsletter
  end
end
