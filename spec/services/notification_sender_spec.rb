require 'rails_helper'

RSpec.describe NotificationSender do
  let!(:users)              { create_list(:user, 5) }
  let!(:items)              { create_list(:item, 5) }
  let!(:following_item_1)   { create(:item) }
  let!(:following_item_2)   { create(:item) }
  let(:follower)            { create(:user) }
  let(:subscription_1)      { create(:subscription, user: follower, item: following_item_1) }
  let(:subscription_2)      { create(:subscription, user: follower, item: following_item_2) }


  context "without new arrivals" do
    before { Item.all.each { |item| item.stock.update(storage_amount: 0) } }

    it "does not send any mail" do
      subscription_1
      subscription_2
      expect(NotificationsMailer).not_to receive(:stock_arrival)
      subject.send_newsletter
    end
  end

  context "with new arrivals" do
    context "without followers" do
      it "does not send any mail" do
        expect(NotificationsMailer).not_to receive(:stock_arrival)
        subject.send_newsletter
      end
    end

    context "with followers" do
      it 'sends new answers list to subscribed users' do
        subscription_1
        subscription_2
        expect(NotificationsMailer).to receive(:stock_arrival).with(user: follower, arrived_items: [following_item_1, following_item_2]).and_call_original
        subject.send_newsletter
      end
    end
  end
end