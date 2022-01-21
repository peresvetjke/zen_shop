# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

3.times do |c|
  category = Category.create!(title: "Category ##{c+1}")

  5.times do |i|
    category.items.create!(
      title: "Item ##{i+1} / cat##{c+1}", 
      description: "DescriptionDescriptionDescription", 
      price: Money.from_cents(1_00*(i+1), "RUB"), 
      weight_gross_gr: 250
    )
  end
end

customer = User.create!(email: "user@example.com", password: "xxxxxx")

5.times do
  order_items = (1..5).to_a.map do 
    item = Item.all.sample
    {
      item_id: item.id, 
      unit_price: item.price, 
      quantity: rand(1..5)
    }
  end
  customer.orders.create!(order_items_attributes: order_items)
end
