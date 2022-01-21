FactoryBot.define do
  sequence(:title) { |n| "Title #{n}" }
  sequence(:email) { |n| "user#{n}@example.com" }
end