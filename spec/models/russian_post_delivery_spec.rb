require 'rails_helper'

RSpec.describe RussianPostDelivery, type: :model do
  let(:delivery) { create(:delivery) }
  
  let(:russian_post_params) {{ 
    from: Delivery::FROM, 
    to: delivery.address.postal_code, 
    weight: delivery.order.weight, 
    sumoc: ConversionRate.exchange(delivery.order.sum, "RUB")
  }}
  
  let(:service_cost) { double(RussianPost::DeliveryCostRetriever) }
  let(:service_time) { double(RussianPost::DeliveryDeadlineRetriever) }

  describe "#cost_rub" do
    it "calls DeliveryParamsRetriever" do
      expect(RussianPost::DeliveryCostRetriever).to receive(:new).with(
        russian_post_params
      ).and_return(service_cost)
      expect(service_cost).to receive(:call)
      delivery.cost
    end
  end

  describe "#planned_date" do
    it "calls DeliveryParamsRetriever" do
      expect(RussianPost::DeliveryDeadlineRetriever).to receive(:new).with(
        russian_post_params
      ).and_return(service_time)
      expect(service_time).to receive(:call)
      delivery.planned_date
    end
  end
end
