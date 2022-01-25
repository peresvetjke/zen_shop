require 'rails_helper'

describe CartItemPolicy do
  subject { CartItemPolicy.new(user, cart_item) }

  let(:u)         { create(:user) }
  let(:cart_item) { create(:cart_item, cart: u.cart) }

  context "for a guest" do
    let(:user) { nil }

    it { should_not permit(:create)  }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end

  context "for an owner" do
    let(:user) { u }

    it { should permit(:update)  }
    it { should permit(:destroy) }
  end

  context "for an another user" do
    let(:user) { create(:user) }

    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }

    it { should permit(:create)      }
  end
end