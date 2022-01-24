class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  validates :amount, numericality: { greater_than_or_equal_to: 1,  only_integer: true }

  validate :validate_available_amount, on: :create, if:-> { item }

  def change_amount_by!(difference)
    validate_available_amount(difference)
    return false if self.errors.present?
    
    self.update(amount: self.amount + difference)
  end

  private

  def validate_available_amount(amount = self.amount)
    errors.add :base, I18n.t("cart_items.errors.not_available") if item.available_amount <= amount
  end
end