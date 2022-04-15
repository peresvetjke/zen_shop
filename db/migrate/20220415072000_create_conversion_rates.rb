class CreateConversionRates < ActiveRecord::Migration[6.1]
  def change
    create_table :conversion_rates do |t|
      t.string :from, null: false
      t.string :to, null: false
      t.decimal :rate, null: false

      t.timestamps
    end
  end
end
