require 'rails_helper'

RSpec.describe RussianPost::DeliveryDeadlineRetriever do
  let(:from)   { 141206 }
  let(:to)     { 101000 }
  let(:weight) { 1000 }
  let(:sumoc)  { Money.new(2000_00, "RUB") }

  subject { RussianPost::DeliveryDeadlineRetriever.new(from: from, to: to, weight: weight, sumoc: sumoc) }

  it "returns deadline for RussianPost delivery" do
    expect(subject.call).to be_instance_of Date
  end
end