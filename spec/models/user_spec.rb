require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:cart).dependent(:destroy) }
    it { should have_one(:bitcoin_wallet).dependent(:destroy) }
    it { should have_many(:bitcoin_purchases).through(:bitcoin_wallet).dependent(:destroy) }
    it { should have_many(:cart_items).through(:cart) }
    it { should have_many(:orders).dependent(:destroy) }
  end
end
