require "rails_helper"

RSpec.describe Admin::OrdersController, :type => :controller do

  let(:user)    { create(:user) }
  let(:order)   { create(:order, :valid) }
  let(:admin)   { create(:user, type: "Admin") }

  describe "GET show" do
    subject { get :show, params: { id: order } }

    shared_examples "guest" do
      it "redirects to sign_in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    shared_examples "customer" do
      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end
    end

    shared_examples "admin" do
      it "renders show template" do
        expect(response).to render_template :show #{ }"admin/orders/show"
      end

      it "assigns the requested order to @order" do
        expect(assigns(:order)).to eq order
      end
    end

    context "being a guest" do
      before { subject }
      it_behaves_like "guest"
    end

    context "being a customer" do
      before {
        sign_in(user)
        subject
      }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { 
        sign_in(admin) 
        subject
      }
      it_behaves_like "admin"
    end
  end

  describe "GET edit" do
    subject { get :edit, params: { id: order } }

    shared_examples "guest" do
      it "redirects to sign_in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    shared_examples "customer" do
      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end
    end

    shared_examples "admin" do
      it "renders edit template" do
        expect(response).to render_template :edit
      end
      
      it "assigns the requested order to @order" do
        expect(assigns(:order)).to eq order
      end
    end

    context "being a guest" do
      before { subject }
      it_behaves_like "guest"
    end

    context "being a customer" do
      before {
        sign_in(user)
        subject
      }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { sign_in(admin) }
      it_behaves_like "admin"
    end
  end

  describe "PATCH update" do
    subject { patch :update, params: { id: order, order: { status: "Processing" } } }

    shared_examples "guest" do
      it "redirects to sign_in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    shared_examples "customer" do
      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end
    end

    shared_examples "admin" do
      it "updates order" do
        expect(response).to render_template :show
      end

      it "renders show template" do
        expect(response).to render_template :show
      end
      
      it "assigns the requested order to @order" do
        expect(assigns(:order)).to eq order
      end
    end

    context "being a guest" do
      before { subject }
      it_behaves_like "guest"
    end

    context "being a customer" do
      before {
        sign_in(user)
        subject
      }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { sign_in(admin) }
      it_behaves_like "admin"
    end
  end
end