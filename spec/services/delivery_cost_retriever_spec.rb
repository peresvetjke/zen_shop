require 'rails_helper'

RSpec.describe RussianPost::DeliveryCostRetriever do
  let(:from)   { 141206 }
  let(:to)     { 101000 }
  let(:weight) { 1000 }
  let(:sumoc)  { Money.new(2000_00, "RUB") }
  let(:rp_tariff_pay_nds_rub) { Money.from_cents(51992, "RUB") }

  subject { RussianPost::DeliveryCostRetriever.new(from: from, to: to, weight: weight, sumoc: sumoc) }

  it "returns cost info for RussianPost delivery" do
    expect(subject.call).to eq rp_tariff_pay_nds_rub
  end
end