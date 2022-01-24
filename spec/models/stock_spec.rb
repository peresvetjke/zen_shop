require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe "associations" do
    it { should belong_to(:item) }
  end

  describe "validations" do
    it { should validate_numericality_of(:storage_amount).is_greater_than_or_equal_to(0) }
  end
end
