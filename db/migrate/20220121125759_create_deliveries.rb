class CreateDeliveries < ActiveRecord::Migration[6.1]
  def change
    create_table :deliveries do |t|
      t.references :order, null: false, foreign_key: true
      t.references :address, null: true, foreign_key: true
      t.integer :type, null: false, default: 0

      t.timestamps
    end
  end
end
