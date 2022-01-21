class AddItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.monetize :price
      t.integer :weight_gross_gr

      t.timestamps
    end
  end
end
