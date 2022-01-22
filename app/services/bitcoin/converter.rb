class Bitcoin::Converter
  BASE_URL = "https://www.blockchain.com/tobtc"
  
  attr_reader :rub_amount
  
  def initialize(rub_money)
    @rub_amount = ActionController::Base.helpers.money_without_cents(rub_money)
  end

  def call
    response = retrieve_info
    Money.new(response.body.to_f * 100_000_000, "BTC")
  end

  def retrieve_info
    http_client = Faraday.new(
      url: BASE_URL,
      params: {
                currency: "RUB",
                value: rub_amount
              }
    )
    http_client.get
  end
end