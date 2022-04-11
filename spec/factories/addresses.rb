FactoryBot.define do
  factory :address do
    country           { generate(:country) }
    postal_code       { 101000 }
    region_with_type  { generate(:region_with_type) }
    city_with_type    { generate(:city_with_type) }
    street_with_type  { generate(:street_with_type) }
    house             { generate(:house) }
    flat              { generate(:flat) }
  end
end
