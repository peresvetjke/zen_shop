require 'rails_helper'

RSpec.describe Bitcoin::BalanceRetriever do
  let(:address_one)         { "1MDUoxL1bGvMxhuoDYx6i11ePytECAk9QK" }
  let(:address_two)         { "15EW3AMRm2yP6LEF5YKKLYwvphy3DmMqN6" }
  let(:addresses)           { [address_one, address_two] }
  let(:example_result)      { {
                                address_one => Money.new(4134, "BTC"),
                                address_two => Money.new(0, "BTC")
                            } }

  subject { Bitcoin::BalanceRetriever.new([address_one, address_two]) }

  it "returns hash with balance info" do
    expect(subject.call).to eq example_result
  end
end