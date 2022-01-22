FactoryBot.define do
  factory :bitcoin_wallet do
    association :user, factory: :user
    balance_btc { Money.new(100000000, "BTC") }
    available_btc { Money.new(50000000, "BTC") }    
  end
end
