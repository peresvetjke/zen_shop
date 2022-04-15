class Money::DollarConversionRateRetriever
  FROM = "USD"
  BASE_URL = "https://openexchangerates.org/api/latest.json?"
  APP_ID = "3aac70087f8f4e2ba9703e6f059e33ff"

  attr_reader :currencies

  def initialize(currencies)
    @currencies = currencies
  end

  def call
    # binding.pry
    response = retrieve_ticker

    result = []
    currencies.each do |currency| 
      rate = JSON.parse(response.body).dig('rates', currency).to_f
      result << { from: FROM, to: currency, rate: rate }
    end
    result
  end

  private

  def retrieve_ticker
    http_client = Faraday.new(
      url: BASE_URL,
      params: {
                app_id: APP_ID,
                base: "USD"
              }
    )
    http_client.get
  end
end