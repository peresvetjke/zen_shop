require 'rails_helper'

RSpec.describe Delivery, type: :model do
  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:address) }
  end
end
