require 'rails_helper'

RSpec.describe RussianPostDelivery, type: :model do
  let(:delivery) { create(:delivery, "RussianPostDelivery") }
  
  let(:russian_post_params) {{ 
    from: Delivery::FROM, 
    to: delivery.address.postal_code, 
    weight: delivery.order.weight, 
    sumoc: ConversionRate.exchange(delivery.order.sum, "RUB")
  }}
  
  let(:service_cost) { double(RussianPost::DeliveryCostRetriever) }
  let(:service_time) { double(RussianPost::DeliveryDeadlineRetriever) }

  describe "validations" do
    subject(:delivery) { build(:delivery) }

    describe "minimum sum" do
      describe "zero sum" do
        before {
          subject.order.order_items.each { |i| i.item.update(price: 0) }
        }
        
        it "is not valid" do
          expect(subject.order.sum).to eq 0
          expect(subject).not_to be_valid
        end
      end

      describe "has minimum sum (1RUB)" do
        it "is valid" do
          expect(subject).to be_valid
        end
      end
    end
  end

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
