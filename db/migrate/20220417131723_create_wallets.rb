class CreateWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :type, null: false, default: 0
      t.integer "balance_cents", default: 0, null: false
      t.string "balance_currency", default: "BTC", null: false

      t.timestamps
    end
  end
end
