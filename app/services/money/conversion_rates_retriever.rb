# update all conversion rates
class Money::ConversionRatesRetriever
  FROM = "USD"
  CURRENCIES = {  
    Money::BitcoinConversionRateRetriever  => ["RUB", "USD"],
    Money::DollarConversionRateRetriever   => ["RUB"]
  }

  def call
    CURRENCIES.each do |rate_retriever, currency|
      response = rate_retriever.new(currency).call
      # [{from: "BTC", to: "RUB", rate: 3289470.20}, {from: "BTC", to: "USD", rate: 39841.272}]

      response.each do |ticker|
        add_rate(ticker[:from], ticker[:to], ticker[:rate])
      end
    end
  end

  private

  def add_rate(from, to, rate)
    MoneyRails.configure do |config| 
      config.add_rate from, to, rate
      config.add_rate to, from, (1.0 / rate)
    end
  end
end

# Money::BitcoinConversionRateRetriever
# between BTC and RUB, USD
# => config.add_rate "RUB", "BTC", ...
# => config.add_rate "BTC", "RUB", ...
# => config.add_rate "USD", "BTC", ...
# => config.add_rate "BTC", "USD", ...

# Money::DollarConversionRateRetriever
# between USD and RUB
# => config.add_rate "RUB", "USD", ...
# => config.add_rate "USD", "RUB", ...