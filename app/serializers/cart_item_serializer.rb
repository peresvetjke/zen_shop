class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :price, :available
  belongs_to :cart

  def price
    object.item.price
  end

  def available
    object.item.stock.storage_amount
  end
end