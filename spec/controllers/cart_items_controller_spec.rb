require "rails_helper"

RSpec.describe CartItemsController, :type => :controller do

  let!(:user)          { create(:user) }
  let!(:item)          { create(:item) }
  let!(:cart_items)    { create_list(:cart_item, 5, cart: user.cart) }
  let!(:cart_item)     { cart_items.first }
  let(:update_params)  { {id: cart_item.id, cart_item: {amount: 1} } }
  let(:create_params)  { {cart_item: {item_id: item.id, amount: 5} } }
  let(:destroy_params) { {id: cart_item.id} }

  describe "POST create" do
    subject { post :create, params: create_params }

    shared_examples "guest" do
      it "keeps count unchanged" do
        expect{subject}.not_to change(CartItem, :count)
      end
    end

    shared_examples "authenticated" do
      it "created cart item in db" do
        expect{subject}.to change(CartItem, :count).by(1)
      end
    end

    context "being a guest" do
      it_behaves_like "guest"
    end

    context "being authenticated" do
      before { sign_in(user) }
      it_behaves_like "authenticated"
    end
  end

  describe "PATCH update" do
    subject { patch :update, params: update_params, format: :json }
    
    shared_examples "guest" do
      it "keeps cart item unchanged" do
        subject
        expect(cart_item.reload.amount).to eq 5
      end
    end

    shared_examples "authenticated" do
      before { subject }

      it "assigns the cart item to @cart_item" do
        expect(assigns(:cart_item)).to eq(cart_item)
      end 

      it "increases cart item's amount" do
        expect(cart_item.reload.amount).to eq 6
      end
    end

    context "being a guest" do
      it_behaves_like "guest"
    end
    
    context "being authenticated" do
      before { sign_in(user) }
      it_behaves_like "authenticated"
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, params: destroy_params, format: :json }

    shared_examples "guest" do
      it "keeps count unchanged" do
        expect{subject}.not_to change(CartItem, :count)
      end
    end

    shared_examples "authenticated" do
      it "deletes record" do
        expect{subject}.to change(CartItem, :count).by(-1)
      end
    end

    context "being a guest" do
      it_behaves_like "guest"
    end
    
    context "being authenticated" do
      before { sign_in(user) }
      it_behaves_like "authenticated"
    end    
  end
end