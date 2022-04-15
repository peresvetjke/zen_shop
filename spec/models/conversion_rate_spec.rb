require 'rails_helper'

RSpec.describe ConversionRate, type: :model do
  let!(:rate)     { create(:conversion_rate, from: "USD", to: "RUB", rate: 82.483862) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:from) }
    it { is_expected.to validate_presence_of(:to) }
    it { is_expected.to validate_presence_of(:rate) }

    describe "uniqueness" do
      let(:duplicate) { build(:conversion_rate, from: "USD", to: "RUB", rate: 80) }

      it "does not allow to create duplicate" do
        expect(duplicate).not_to be_valid
      end
    end
  end

  describe ".exchange" do
    let(:money_usd) { Money.new(1_00, "USD") }

    it "calculates money of target currency" do
      expect(ConversionRate.exchange(money_usd, "RUB")).to eq Money.new(82_48, "RUB")
    end
  end
end