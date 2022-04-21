class AddCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :title, null: false, unique: true

      t.timestamps
    end
  end
end
