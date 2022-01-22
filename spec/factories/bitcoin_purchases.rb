FactoryBot.define do
  factory :bitcoin_purchase do
    association :bitcoin_wallet, factory: :bitcoin_wallet
    association :order, factory: :order
    amount_btc_cents { Money.new(50, "BTC") }    
  end
end
