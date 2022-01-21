class Order < ApplicationRecord
  belongs_to :user
  has_one :delivery, dependent: :destroy
  has_one :address, through: :delivery
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :delivery, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  validate :at_least_one_delivery
  validate :at_least_one_order_item

  def total_sum
    order_items.map { |order_item| order_item.unit_price * order_item.quantity }.sum
  end

  def total_cost
    total_sum + delivery.cost_rub
  end

  def total_weight
    order_items.map { |order_item| order_item.item.weight_gross_gr * order_item.quantity }.sum
  end

  def build_address(params)
    self.address = Address.new(params)
  end  

  private

  def at_least_one_delivery
    errors.add :base, "Must have at least one Delivery." unless delivery.present?

    # when updating an existing contact: Making sure that at least one team would exist
    # return errors.add :base, "Must have at least one Delivery." if contacts_teams.reject{|contacts_team| contacts_team._destroy == true}.empty?
  end
  
  def at_least_one_order_item
    errors.add :base, "Must have at least one line item." unless order_items.present?
  end
end
