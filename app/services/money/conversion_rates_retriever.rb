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
      # => [{from: "BTC", to: "RUB", rate: 3289470.20}, {from: "BTC", to: "USD", rate: 39841.272}]

      response.each do |ticker|
        add_rate(ticker[:from], ticker[:to], ticker[:rate])
        add_rate(ticker[:to], ticker[:from], 1.0 / ticker[:rate])
      end
    end
  end

  private

  def add_rate(from, to, rate)
    conversion_rate = ConversionRate.find_or_initialize_by(from: from, to: to)
    conversion_rate.update(rate: rate)
    conversion_rate.save
  end
end