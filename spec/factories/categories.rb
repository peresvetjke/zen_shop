FactoryBot.define do
  factory :category do
    title { generate(:title) }
  end
end