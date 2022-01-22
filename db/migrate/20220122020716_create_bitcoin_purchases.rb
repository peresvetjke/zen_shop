class CreateBitcoinPurchases < ActiveRecord::Migration[6.1]
  def change
    create_table :bitcoin_purchases do |t|
      t.references :bitcoin_wallet, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer "amount_btc_cents", default: 0, null: false
      t.string "amount_btc_currency", default: "BTC", null: false

      t.timestamps
    end
  end
end
