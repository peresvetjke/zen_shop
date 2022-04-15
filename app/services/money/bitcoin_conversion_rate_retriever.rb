class Money::BitcoinConversionRateRetriever
  FROM = "BTC"
  BASE_URL = "https://blockchain.info/ticker"

  attr_reader :currencies

  def initialize(currencies)
    @currencies = currencies
  end

  def call
    response = retrieve_ticker

    result = []
    currencies.each do |currency| 
      rate = JSON.parse(response.body).dig(currency, "buy").to_f
      result += [{from: FROM, to: currency, rate: rate}] 
    end
    result
  end

  private

  def retrieve_ticker
    Faraday.new(url: BASE_URL).get
  end
end