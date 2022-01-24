class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :storage_amount, default: 0

      t.timestamps
    end
  end
end
