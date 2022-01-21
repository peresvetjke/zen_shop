FactoryBot.define do
  factory :address do
    country { "MyString" }
    postal_code { "MyString" }
    region_with_type { "MyString" }
    city_with_type { "MyString" }
    street_with_type { "MyString" }
    house { "MyString" }
    flat { "MyString" }    
  end
end
