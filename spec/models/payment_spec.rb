require 'rails_helper'

RSpec.describe Payment, type: :model do
  # subject { build(:purchase) }

  describe "associations" do
    it { should belong_to(:wallet) }
    it { should belong_to(:order) }

    # it "belongs to user" do
    #   expect(subject.user.class).to be < User
    # end
  end
end
