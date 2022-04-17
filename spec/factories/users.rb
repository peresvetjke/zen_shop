FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { "xxxxxx" }
    type { "Customer" }

    trait(:no_money) do
      after(:create) do |user|
        user.wallet.update(balance_cents: 0)
        user.wallet.save
      end
    end
  end
end
