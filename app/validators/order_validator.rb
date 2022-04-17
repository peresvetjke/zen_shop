class OrderValidator < ActiveModel::Validator

  def validate(order)
    @order = order
    validate_delivery_type_presence
    validate_at_least_one_order_item

    if @order.order_items.present?
      validate_enough_money
    end

    if order.delivery_type == "Self-pickup"
      validate_delivery_absence
    else
      validate_at_least_one_delivery 
      validate_minimum_sum
      validate_address_exists
    end
  end

  private

  def validate_at_least_one_order_item
    unless @order.order_items.present?
      @order.errors.add :base, "Must have at least one line item."
    end
  end

  def validate_delivery_type_presence
    unless @order.delivery_type.present?
      @order.errors.add :delivery_type, "can't be blank."
    end
  end

  def validate_delivery_absence
    if @order.delivery.present?
      @order.errors.add :base, "is not expected to have Delivery."
    end
  end

  def validate_at_least_one_delivery
    unless @order.delivery.present?
      @order.errors.add :base, "Must have at least one Delivery."
    end
  end

  def validate_address_exists
    if @order.address.nil?
      @order.errors.add :base, "Must have address."
    end
  end

  def validate_minimum_sum
    unless has_minimum_sum?
      @order.errors.add :base, "Declared value can't be less than 1 RUB"
    end
  end

  def validate_enough_money
    wallet = @order.user.wallet
    total_cost = ConversionRate.exchange(@order.total_cost, @order.currency)
    insufficient = total_cost - wallet.balance
    
    if insufficient > 0
      @order.errors.add :base, "Not enough #{wallet.balance_btc_currency} for an order. Please replenish your wallet for #{insufficient}."
    end
  end

  def has_minimum_sum?
    sum_rub = ConversionRate.exchange(@order.sum, "RUB")
    sum_rub >= Order::MINIMUM_SUM_RUB
  end
end