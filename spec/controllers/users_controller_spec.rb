require "rails_helper"

RSpec.describe UsersController, :type => :controller do
  let(:user)    { create(:user) }

  describe "GET show" do
    subject { get :show }

    shared_examples "guest" do
      it "redirects to sign_in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    shared_examples "authenticated" do
      it "renders show template" do
        expect(response).to render_template :show
      end
      
      it "assigns current_user to @user" do
        expect(assigns(:user)).to eq user
      end
    end

    context "being a guest" do
      before { subject }
      it_behaves_like "guest"
    end

    context "being authenticated" do
      before {
        sign_in(user)
        subject
      }
      it_behaves_like "authenticated"
    end
  end
end