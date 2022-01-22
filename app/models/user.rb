class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :cart, dependent: :destroy
  has_many :cart_items, through: :cart
  has_many :orders, dependent: :destroy
  has_one :bitcoin_wallet, dependent: :destroy
  has_many :bitcoin_purchases, through: :bitcoin_wallet, dependent: :destroy

  after_create :create_cart
  after_create :create_bitcoin_wallet
end
