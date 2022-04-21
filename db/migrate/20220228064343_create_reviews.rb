class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :author_id
      t.references :item, null: false, foreign_key: true
      t.integer :rating, null: false

      t.timestamps
    end

    add_index :reviews, [:author_id, :item_id], unique: true
  end
end
