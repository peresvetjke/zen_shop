class Delivery < ApplicationRecord
  FROM = 141230 # post index of our plant

  enum delivery_type: { "Self-pickup" => 0, "Russian Post" => 1 }

  belongs_to :order
  belongs_to :address, optional: true
  validates :delivery_type, presence: true

  def cost_rub
    case delivery_type
    when "Self-pickup"
      0
    when "Russian Post"
      RussianPost::DeliveryCostRetriever.new(from: FROM, to: self.address.postal_code, sumoc: order.total_sum, weight: order.total_weight).call
    end
  end

  def planned_date
    case delivery_type
    when "Self-pickup"
      Date.today
    when "Russian Post"
      RussianPost::DeliveryDeadlineRetriever.new(from: FROM, to: self.address.postal_code, sumoc: order.total_sum, weight: order.total_weight).call
    end
  end
end
