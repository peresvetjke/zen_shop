require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) { create(:review) }

  describe "associations" do
    it { should belong_to(:author).class_name("User") }
  end

  describe "validations" do
    it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5).only_integer }
    it { should validate_presence_of(:body) }

    it "does not allow to create more than one review" do

    end
  end
end 
