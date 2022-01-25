require "rails_helper"

RSpec.describe OrdersController, :type => :controller do

  let(:user)    { create(:user) }
  let(:orders)  { create_list(:order, 5) }
  let(:order)   { orders.first }

  describe "GET new" do
    subject { get :new }
    
    shared_examples "guest" do
      it "redirects to sign_in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    shared_examples "authenticated" do
      it "renders new template" do
        expect(response).to render_template :new
      end

      it "assigns user's cars to @cart" do
        expect(assigns(:cart)).to eq user.cart
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

  describe "POST create" do
    let(:params) { { order: 
                            { order_items_attributes: [ {
                                                        item_id: create(:item).id, 
                                                        unit_price: Money.new(100_00, "RUB"),
                                                        quantity: 5 
                                                    } ],
                              delivery_attributes: { delivery_type: "Self-pickup" }
                            } 
                 } }
         
    subject { post :create, params: params }

    shared_examples "guest" do
      it "redirects to sign_in path" do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end

    shared_examples "authenticated" do
      it "assigns user's cart to @cart" do
        subject
        expect(assigns(:cart)).to eq user.cart
      end

      context "with invalid params" do
        let(:params) { { order: 
                                { order_items_attributes: [ {
                                                            item_id: rand(1..1000), 
                                                            unit_price: Money.new(100_00, "RUB"),
                                                            quantity: 5 
                                                        } ],
                                  delivery_attributes: { delivery_type: "Self-pickup" }
                                } 
                     } }

        it "does not create new order in db" do
          expect{subject}.not_to change(Order, :count)
        end

        it "renders new" do
          subject
          expect(response).to render_template :new        
        end
      end

      context "with valid params" do
        it "creates new order in db" do
          expect{subject}.to change(Order, :count).by(1)
        end

        it "renders show template with order" do
          subject
          expect(response).to redirect_to order_path(Order.last)
        end
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

  describe "GET index" do
    subject { get :index }

    shared_examples "guest" do
      it "redirects to sign_in path" do
        expect(response).to redirect_to new_user_session_path
      end      
    end

    shared_examples "authenticated" do
      it "renders index template" do
        expect(response).to render_template :index
      end

      it "assigns all users' orders to @orders" do
        expect(assigns(:orders)).to match_array(user.orders)
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

  describe "GET show" do
    subject { get :show, params: { id: order } }

    shared_examples "guest" do
      it "redirects to sign_in path" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    shared_examples "author of order" do
      it "renders show template" do
        expect(response).to render_template :show
      end
      
      it "assigns the requested order to @order" do
        expect(assigns(:order)).to eq order
      end
    end

    shared_examples "another user" do
      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "being a guest" do
      before { subject }
      it_behaves_like "guest"
    end

    context "being an another user" do
      before {
        sign_in(user)
        subject
      }
      it_behaves_like "another user"
    end

    context "being an author of order" do
      before {
        sign_in(order.user)
        subject
      }
      it_behaves_like "author of order"
    end
  end
end