require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "associations" do
    it { should belong_to(:author).class_name("User") }
  end

  describe "validations" do
    it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5).only_integer }
    it { should validate_presence_of(:body) }

    describe "uniqueness" do
      let(:user)   { create(:user) }
      let(:item)   { create(:item) }
      let(:review) { create(:review, item: item, author: user) }
      
      it "does not allow to create more than one review" do
        review
        expect(build(:review, item: item, author: user)).not_to be_valid
      end
    end
  end
end