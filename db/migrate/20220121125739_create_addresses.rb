class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :country
      t.string :postal_code, null: false
      t.string :region_with_type
      t.string :city_with_type
      t.string :street_with_type
      t.string :house
      t.string :flat

      t.timestamps
    end
  end
end
