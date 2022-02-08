class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :amount

  belongs_to :cart
  belongs_to :item
end