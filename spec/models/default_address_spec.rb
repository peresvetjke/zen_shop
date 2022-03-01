require 'rails_helper'

RSpec.describe DefaultAddress, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:address) }
  end
end
