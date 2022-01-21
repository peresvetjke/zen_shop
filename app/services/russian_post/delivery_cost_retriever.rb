class RussianPost::DeliveryCostRetriever < RussianPost::DeliveryInfoRetriever
  protected

  def parse(response)
    Money.new(response['paynds'], "RUB")
  end
end