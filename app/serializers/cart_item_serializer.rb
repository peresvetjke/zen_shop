class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :amount, :price
  belongs_to :cart

  def price
    object.item.price
  end
end