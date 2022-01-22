class Bitcoin::BalanceRetriever
  BASE_URL = "https://blockchain.info/balance?active="

  attr_reader :addresses
  
  def initialize(addresses)
    @addresses = addresses.class == String ? [addresses] : addresses
  end

  def call
    response = retrieve_info

    JSON.parse(response.body).map do |address, info| 
      current_balance = Money.new(info['final_balance'], "BTC")
      [address, current_balance]
    end.to_h
  end

  def retrieve_info
    http_client = Faraday.new(url: BASE_URL + addresses.join("|"))
    http_client.get    
  end
end