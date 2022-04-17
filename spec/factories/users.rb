FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { "xxxxxx" }
    type { "Customer" }

    after(:build) do |user|
      build(:bitcoin_wallet, user: user)
    end

    trait(:no_money) do
      after(:create) do |user|
        user.bitcoin_wallet.update(available_btc: Money.new(0, "BTC"))
        user.bitcoin_wallet.save
      end
    end
  end
end
