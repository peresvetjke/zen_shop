require 'rails_helper'

RSpec.describe Money::ConversionRatesRetriever do

  let(:bitcoin_rate_retriever) { double(Money::BitcoinConversionRateRetriever) }
  let(:dollar_rate_retriever)  { double(Money::DollarConversionRateRetriever) }

  subject { Money::ConversionRatesRetriever.new }

  it "calls Money::BitcoinConversionRateRetriever" do
    expect(Money::BitcoinConversionRateRetriever).to receive(:new).with(["RUB", "USD"])
      .and_return(bitcoin_rate_retriever)
    expect(bitcoin_rate_retriever).to receive(:call).and_return([])
    subject.call
  end

  it "calls Money::DollarConversionRateRetriever" do
    expect(Money::DollarConversionRateRetriever).to receive(:new).with(["RUB"])
      .and_return(dollar_rate_retriever)
    expect(dollar_rate_retriever).to receive(:call).and_return([])
    subject.call
  end

  it "updates USD conversion rates" do
    allow(Money::DollarConversionRateRetriever).to receive(:new).with(["RUB"])
      .and_return(dollar_rate_retriever)
    allow(dollar_rate_retriever).to receive(:call).and_return(
      [{from: "USD", to: "RUB", rate: 10}]
    )
    subject.call

    expect(ConversionRate.exchange(Money.new(1_00, "USD"), "RUB")).to eq Money.new(10_00, "RUB")
    expect(ConversionRate.exchange(Money.new(10_00, "RUB"), "USD")).to eq Money.new(1_00, "USD")
  end

  it "updates BTC conversion rates" do
    allow(Money::BitcoinConversionRateRetriever).to receive(:new).with(["RUB", "USD"])
      .and_return(bitcoin_rate_retriever)
    allow(bitcoin_rate_retriever).to receive(:call).and_return(
      [{from: "USD", to: "BTC", rate: 0.0000251001}]
    )
    subject.call

    expect(ConversionRate.exchange(Money.new(1_00, "BTC"), "USD")).to eq Money.new(39_840_48, "USD")
  end
end