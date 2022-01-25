require 'rails_helper'

describe ItemPolicy do
  subject { ItemPolicy.new(user, item) }

  let(:item) { create(:item) }

  context "for a guest" do
    let(:user) { nil }

    it { should_not permit(:subscribe) }
    
    it { should permit(:show)      }
    it { should permit(:search)    }
  end

  context "for a user" do
    let(:user) { create(:user) }

    it { should permit(:show)      }
    it { should permit(:search)    }
    it { should permit(:subscribe) }
  end
end