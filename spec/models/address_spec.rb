require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'associations' do
    it { should have_many(:deliveries).dependent(:destroy) }
  end
end
