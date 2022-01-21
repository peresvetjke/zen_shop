class CartSerializer < ActiveModel::Serializer
  attributes :id, :total_sum, :total_weight
end
