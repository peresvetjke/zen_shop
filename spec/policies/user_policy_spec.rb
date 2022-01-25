require 'rails_helper'

describe UserPolicy do
  subject { UserPolicy.new(user, user) }

  context "for a guest" do
    let(:user) { nil }

    it { should_not permit(:show) }
  end
  
  context "for a user" do
    let(:user) { create(:user) }

    it { should permit(:show) }
  end
end