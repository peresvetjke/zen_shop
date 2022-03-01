class CreateDefaultAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :default_addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
