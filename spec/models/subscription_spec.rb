require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:service)       { double(NotificationSender) }

  describe "associations" do
    it { should belong_to(:item) }
    it { should belong_to(:user) }
  end

  describe ".send_notifications" do
    it "calls service" do
      expect(NotificationSender).to receive(:new).and_return(service)
      expect(service).to receive(:call)
      Subscription.send_notifications
    end
  end
end