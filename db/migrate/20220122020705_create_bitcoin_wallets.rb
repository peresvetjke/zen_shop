class CreateBitcoinWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :bitcoin_wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.integer "balance_btc_cents", default: 0, null: false
      t.string "balance_btc_currency", default: "BTC", null: false
      t.integer "available_btc_cents", default: 0, null: false
      t.string "available_btc_currency", default: "BTC", null: false

      t.timestamps
    end
  end
end
