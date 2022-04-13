class AddImageUrlToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :google_image_id, :string
  end
end
