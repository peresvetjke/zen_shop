class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :delivery_type, null: false
      t.string :currency, default: "BTC", null: false
      
      t.timestamps
    end
  end
end
