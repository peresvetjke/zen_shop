class RussianPostDelivery < Delivery
  def cost
    RussianPost::DeliveryCostRetriever.new(params).call
  end

  def planned_date
    RussianPost::DeliveryDeadlineRetriever.new(params).call
  end

  private

  def params
    { from: FROM, 
      to: self.address.postal_code, 
      sumoc: ConversionRate.exchange(order.sum, "RUB"), 
      weight: order.weight 
    }
  end
end