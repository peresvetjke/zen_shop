FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { "xxxxxx" }
  end
end
