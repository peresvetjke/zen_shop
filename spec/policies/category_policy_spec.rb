require 'rails_helper'

describe CategoryPolicy do
  subject { CategoryPolicy.new(user, category) }

  let(:category) { create(:category) }

  context "for a guest" do
    let(:user) { nil }

    it { should_not permit(:index)   }
    it { should_not permit(:show)    }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end

  context "for a customer" do
    let(:user) { create(:user, type: "Customer") }

    it { should_not permit(:index)   }
    it { should_not permit(:show)    }
    it { should_not permit(:new)     }
    it { should_not permit(:create)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:update)  }
    it { should_not permit(:destroy) }
  end

  context "for an admin" do
    let(:user) { create(:user, type: "Admin") }

    it { should permit(:index)   }
    it { should permit(:show)    }
    it { should permit(:new)     }
    it { should permit(:create)  }
    it { should permit(:edit)    }
    it { should permit(:update)  }
    it { should permit(:destroy) }
  end
end