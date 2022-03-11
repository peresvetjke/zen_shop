class Category < ApplicationRecord
  after_create_commit { broadcast_append_to "categories", partial: "admin/categories/category" }
  after_update_commit { broadcast_replace_to "categories", partial: "admin/categories/category" }
  after_destroy_commit { broadcast_remove_to "categories" }

  has_many :items
  
  validates :title, presence: true
  validates :title, uniqueness: true
end