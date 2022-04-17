class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :wallet, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer "amount_cents", null: false
      t.string "amount_currency", null: false

      t.timestamps
    end
  end
end
