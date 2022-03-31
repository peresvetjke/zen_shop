FactoryBot.define do
  sequence(:title) { |n| "Title #{n}" }
  sequence(:email) { |n| "user#{n}@example.com" }
  
  sequence(:country)          { |n| "country#{n}" }
  sequence(:postal_code)      { |n| "postal#{n}" }
  sequence(:region_with_type) { |n| "region#{n}" }
  sequence(:city_with_type)   { |n| "city#{n}" }
  sequence(:street_with_type) { |n| "street#{n}" }
  sequence(:house)            { |n| "house#{n}" }
  sequence(:flat)             { |n| "flat#{n}" }
end