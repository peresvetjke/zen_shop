class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :item

  def self.send_notifications
    NotificationSender.new.call
  end
end
