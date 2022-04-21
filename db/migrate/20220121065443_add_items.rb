class AddItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :title, null: false, unique: true
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.monetize :price, null: false
      t.integer :weight_gross_gr, null: false

      t.timestamps
    end
  end
end
