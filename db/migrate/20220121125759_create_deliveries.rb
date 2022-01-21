class CreateDeliveries < ActiveRecord::Migration[6.1]
  def change
    create_table :deliveries do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :delivery_type, null: false
      t.references :address, null: true, foreign_key: true

      t.timestamps
    end
  end
end
