require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "associations" do
    it { should belong_to(:order) }
    it { should belong_to(:item) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1).only_integer }
  end
end