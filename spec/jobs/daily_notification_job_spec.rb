require 'rails_helper'

RSpec.describe DailyNotificationJob, type: :job do
  it "calls Daily Notification Service" do
    allow_any_instance_of(NotificationSender).to receive(:send_newsletter)
    DailyNotificationJob.perform_now
  end
end