require 'rails_helper'

RSpec.describe Delivery, type: :model do
  let(:address) { create(:address, postal_code: 141206) }
  let(:price)   { Money.from_cents(250_00, "RUB") }
  let(:item)    { create(:item, price: price, weight_gross_gr: 1000) }
  let(:user)    { create(:user) }
  let(:order)   {
    Order.create(
        user: user, 
        order_items_attributes: [item_id: item.id, unit_price: item.price, quantity: 2],
        delivery_attributes: {delivery_type: 1},
        address_attributes: attributes_for(:address, postal_code: 141206)
    )
  }
  let(:service_cost) { double(RussianPost::DeliveryCostRetriever) }
  let(:service_time) { double(RussianPost::DeliveryDeadlineRetriever) }

  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:address).optional(true) }
  end

  describe 'validations' do
    it { should validate_presence_of(:delivery_type) }
  end

  describe "#cost_rub" do
    context "self_pickup" do
      it "returns zero value" do
        order.delivery.delivery_type = 0
        expect(order.delivery.cost_rub).to eq 0
      end
    end

    context "russian_post" do
      it "calls DeliveryParamsRetriever" do
        expect(RussianPost::DeliveryCostRetriever).to receive(:new).with(
          from: Delivery::FROM, 
          to: order.address.postal_code, 
          weight: order.total_gross_weight_gr, 
          sumoc: order.total_sum_rub
        ).and_return(service_cost)
        expect(service_cost).to receive(:call)
        order.delivery.cost_rub
      end
    end
  end

  describe "#planned_date" do
    context "self_pickup" do
      it "returns zero value" do
        order.delivery.delivery_type = 0
        expect(order.delivery.planned_date).to eq Date.today
      end
    end

    context "russian_post" do
      it "calls DeliveryParamsRetriever" do
        expect(RussianPost::DeliveryDeadlineRetriever).to receive(:new).with(
          from: Delivery::FROM, 
          to: order.address.postal_code, 
          weight: order.total_gross_weight_gr, 
          sumoc: order.total_sum_rub
        ).and_return(service_time)
        expect(service_time).to receive(:call)
        order.delivery.planned_date
      end
    end
  end
end
