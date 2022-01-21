require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { build(:category) }
  
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
  end

  describe 'associations' do
    it { should have_many(:items) }
  end
end