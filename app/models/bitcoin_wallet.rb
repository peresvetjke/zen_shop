class BitcoinWallet < Wallet
  
  def self.update_balances
    balances = BitcoinWallet.current_balances

    self.all.each do |btc_wallet|
      current_balance = balances[btc_wallet.public_address] if balances
      if current_balance != btc_wallet.balance
        btc_wallet.update(balance_cents: current_balance)
        btc_wallet.save
      end
    end
  end

  def public_address
    node = BitcoinWallet.master_wallet.node_for_path "M/0/#{user.id}"
    node.to_bip32
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
