FactoryBot.define do
  factory :bitcoin_wallet do
    association :user, factory: :user
    balance_btc { Money.new(1_0000_0000, "BTC") }
    available_btc { Money.new(5000_0000, "BTC") }    
  end
end
