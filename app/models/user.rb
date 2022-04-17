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
  has_many :wallets, dependent: :destroy
  has_one  :default_wallet, dependent: :destroy
  has_many :payments, through: :wallets, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :reviews, dependent: :destroy, foreign_key: "author_id"

  delegate :address, to: :default_address, allow_nil: true
  delegate :wallet, to: :default_wallet, allow_nil: true

  after_create :create_cart
  after_create :charge_dummy_btc_wallet

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

  def charge_dummy_btc_wallet
    wallet = wallets.create!(balance: Money.new(1_0000_0000, "BTC"))
    create_default_wallet!(wallet: wallet)
  end
end
