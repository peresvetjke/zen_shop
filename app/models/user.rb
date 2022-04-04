class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]

  enum type: { "Admin" => 0, "Customer" => 1 }

  has_many :authentications, dependent: :destroy
  has_one :default_address, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :cart_items, through: :cart
  has_many :orders, dependent: :destroy
  has_one :bitcoin_wallet, dependent: :destroy
  has_many :bitcoin_purchases, through: :bitcoin_wallet, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :reviews, dependent: :destroy, foreign_key: "author_id"

  delegate :address, to: :default_address, allow_nil: true

  after_create :create_cart
  after_create :create_bitcoin_wallet
  after_create :charge_dummy_btc

  def self.find_for_oauth(auth)
    Omni::AuthFinder.new(auth).call
  end

  def owner_of?(object)
    object.user_id == id
  end

  def subscribe!(item:)
    subscription = Subscription.find_or_initialize_by(user: self, item: item)
    if subscription.persisted?
      subscription.destroy
      I18n.t("items.unsubscribed")
    else
      subscription.save
      I18n.t("items.subscribed")
    end
  end

  def subscribed?(item:)
    Subscription.where(user: self, item: item).present?
  end

  def admin?
    type == "Admin"
  end

  def create_authentication(provider:, uid:)
    authentications.create!(provider: provider, uid: uid)
  end

  def charge_dummy_btc
    bitcoin_wallet.update(available_btc: Money.new(100_000_000, "BTC"))
    bitcoin_wallet.save
  end
end
