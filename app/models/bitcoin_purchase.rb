class BitcoinPurchase < ApplicationRecord
  belongs_to :bitcoin_wallet
  belongs_to :order

  delegate :user, :to => :bitcoin_wallet, :allow_nil => false

  monetize :amount_btc_cents, as: "amount_btc"

  after_create :update_wallet_available_amount

  private

  def update_wallet_available_amount
    bitcoin_wallet.available_btc -= amount_btc
  end
end
