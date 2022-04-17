require 'rails_helper'

RSpec.describe ConversionRate, type: :model do
  # let(:conversion_rate) { ConversionRate.find_by(from: "USD", to: "RUB") }
  # let(:rate)            { conversion_rate.rate }

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
    describe "calculation" do
      describe "RUB -> BTC" do
        it "returns money of target currency" do
          expect(ConversionRate.find_by(from: "BTC", to: "RUB").rate).to eq 3_289_470.20

          money_btc = Money.new(1_0000_0000, "BTC")
          money_rub = Money.new(3_289_470_20, "RUB")

          expect(ConversionRate.exchange(money_btc, "RUB")).to eq money_rub
        end
      end

      describe "RUB -> USD" do
        it "returns money of target currency" do
          ConversionRate.find_by(from: "USD", to: "RUB").update!(rate: 80)

          money_usd = Money.new(1_00, "USD")
          money_rub = Money.new(80_00, "RUB")

          expect(ConversionRate.exchange(money_usd, "RUB")).to eq money_rub
        end
      end
    end

    describe "same source and target currencies" do
      let(:money_usd) { Money.new(1000_00, "USD") }

      it "returns source money" do
        expect(ConversionRate.exchange(money_usd, "USD")).to eq money_usd
      end
    end
  end
end