require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe "associations" do
    it { should belong_to(:wallet) }
    it { should belong_to(:order) }
  end
end
