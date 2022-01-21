class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true

  validate :at_least_one_order_item

  def total_sum
    order_items.map { |order_item| order_item.unit_price * order_item.quantity }.sum
  end

  private

  def at_least_one_order_item
    errors.add :base, "Must have at least one line item." unless order_items.present?
  end  
end
