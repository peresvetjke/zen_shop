require 'rails_helper'

describe OrderPolicy do
  subject { OrderPolicy.new(user, order) }

  let(:order) { create(:order) }

  context "for a guest" do
    let(:user) { nil }

    it { should_not permit(:show)   }
    it { should_not permit(:new)    }
    it { should_not permit(:create) }
  end

  context "for an order's owner" do
    let(:user) { order.user }

    it { should permit(:show) }
  end

  context "for an other user" do
    let(:user) { create(:user) }

    it { should_not permit(:show) }

    it { should permit(:new)      }
    it { should permit(:create)   }
  end
end