require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:postal_code) }
  end

  describe 'associations' do
    it { should have_many(:deliveries).dependent(:destroy) }
  end
end
