class RussianPostDelivery < Delivery
  MINIMUM_SUM_RUB = Money.new(1_00, "RUB")

  validate :validate_minimum_sum, if: -> { order&.order_items.present? }

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

  def validate_minimum_sum
    unless has_minimum_sum?
      errors.add :base, "Declared value can't be less than 1 RUB"
    end
  end

  def has_minimum_sum?
    sum_rub = ConversionRate.exchange(order.sum, "RUB")
    sum_rub >= MINIMUM_SUM_RUB
  end
end