class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  validates :amount, numericality: { greater_than_or_equal_to: 1,  only_integer: true }
  validate :validate_available_amount, on: [:create, :update], if:-> { item }

  private

  def validate_available_amount
    updated = self.amount
    current = self.persisted? ? self.reload.amount : 0
    errors.add :base, I18n.t("cart_items.errors.not_available") if item.available_amount < updated - current
    self.amount = updated
  end
end