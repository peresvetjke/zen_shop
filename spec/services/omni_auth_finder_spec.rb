require 'rails_helper'

RSpec.describe Omni::AuthFinder do
  let(:user)            { create(:user) }
  let(:auth_with_email)    { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }
  let(:auth_without_email) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
  
  context "authentication exists" do
    let!(:authentication)  { create(:authentication, provider: 'github', uid: '123456', user: user) }
    
    subject { Omni::AuthFinder.new(auth_without_email) }

    it "doesn't create new authentications" do
      expect { subject.call }.not_to change(Authentication, :count)
    end

    it "doesn't create new users" do
      expect { subject.call }.not_to change(Authentication, :count)
    end

    it 'returns user' do
      expect(subject.call).to eq(user)
    end
  end   

  context "authentication does not exist" do
    context "email provided" do
      context 'user exists' do
        before { user }
        subject { Omni::AuthFinder.new(auth_with_email) }

        it "doesn't create new user" do
          expect { subject.call }.not_to change(User, :count)
        end

        it 'creates new authentication' do
          expect{ subject.call }.to change(Authentication, :count).by(1)
          expect(user.authentications.last.user).to eq(user)
        end

        it 'returns user' do
          expect(subject.call).to eq(user)
        end        
      end

      context 'user does not exist' do
        subject { Omni::AuthFinder.new(auth_with_email) }

        it 'creates user' do
          expect{ subject.call }.to change(User, :count).by(1)
        end
        
        it 'confirms user account' do
          expect{ subject.call }.to change(User, :count).by(1)
        end

        it 'creates new authentication' do
          expect{ subject.call }.to change(Authentication, :count).by(1)
          expect(user.authentications.last.user).to eq(user)
        end

        it 'returns user' do
          expect(subject.call).to eq(user)
        end
      end
    end

    context "no email provided" do
      subject { Omni::AuthFinder.new(auth_without_email) }

      it 'does not create user' do
        expect{ subject.call }.not_to change(User, :count)
      end

      it 'does not create authentication' do
        expect{ subject.call }.not_to change(Authentication, :count)
      end

      it 'returns nil' do
        expect(subject.call).to be_nil
      end
    end
  end
end