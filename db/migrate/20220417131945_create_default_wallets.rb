class CreateDefaultWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :default_wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :wallet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
