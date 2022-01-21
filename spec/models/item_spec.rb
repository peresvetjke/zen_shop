require 'rails_helper'

RSpec.describe Item, type: :model do
  subject { build(:item) }

  describe 'validations' do
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_numericality_of(:weight_gross_gr).is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to(:category) }
  end
end