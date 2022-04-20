class Payment < ApplicationRecord
  belongs_to :wallet
  belongs_to :order

  delegate :user, to: :wallet

  validates :amount_cents, numericality: { greater_than: 0 }
  validate :matching_user,           if: -> { order.present? && wallet.present? }
  validate :matching_currency,       if: -> { wallet.present? }

  monetize :amount_cents, as: "amount"

  def post!
    ActiveRecord::Base.transaction do
      save!
      wallet.update!(balance: wallet.balance - amount)
    rescue
      raise ActiveRecord::Rollback
    end
  end

  private

  def matching_currency
    unless wallet.currency == amount_currency
      errors.add :amount_currency, "does not match wallet currency: #{wallet.currency}"
    end
  end

  def matching_user
    unless wallet.user == order.user
      errors.add :order, "does not match to wallet's user."
    end
  end
end
