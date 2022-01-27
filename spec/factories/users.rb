FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { "xxxxxx" }
    type { "Customer" }

    after(:create) do |user|
      user.bitcoin_wallet.update(available_btc: Money.new(100_000_000, "BTC"))
      user.bitcoin_wallet.save
    end

    trait(:no_money) do
      after(:create) do |user|
        user.bitcoin_wallet.update(available_btc: Money.new(0, "BTC"))
        user.bitcoin_wallet.save
      end
    end
  end
end
