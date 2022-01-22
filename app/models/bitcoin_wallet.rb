class BitcoinWallet < ApplicationRecord
  belongs_to :user
  has_many :bitcoin_purchases

  monetize :balance_btc_cents, as: "balance_btc"
  monetize :available_btc_cents, as: "available_btc"

  def self.update_balances
    balances = BitcoinWallet.current_balances

    self.all.each do |btc_wallet|
      current_balance = balances[btc_wallet.public_address] if balances
      if current_balance != btc_wallet.balance_btc
        btc_wallet.update(balance_btc_cents: current_balance)
        btc_wallet.save
      end
    end
  end

  def public_address
    node = BitcoinWallet.master_wallet.node_for_path "M/0/#{user.id}"
    node.to_bip32
  end

  def calculate_insufficient_btc_amount(money_rub:)
    raise "Expecting RUB currency for an argument." unless money_rub.currency.id == :rub
    
    required_btc = Bitcoin::Converter.new(money_rub).call
    required_btc > available_btc ? required_btc - available_btc : 0
  end

  private

  def self.master_wallet
    MoneyTree::Master.new seed_hex: Rails.application.credentials.bitcoin[:master_seed_hex]
  end

  def self.current_balances
    public_addresses = all.map(&:public_address)
    Bitcoin::BalanceRetriever.new(public_addresses).call
  end
end
