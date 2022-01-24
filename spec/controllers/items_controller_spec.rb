require "rails_helper"

RSpec.describe ItemsController, :type => :controller do

  let(:user)  { create(:user) }
  let(:items) { create_list(:item, 5) }
  let(:item)  { items.first }

  describe "GET index" do
    before { get :index }
    
    it "renders index template" do
      expect(response).to render_template :index
    end

    it "assigns the all items to @items" do
      expect(assigns(:items)).to match_array(items)
    end
  end

  describe "GET show" do
    before { get :show, params: { id: item } }

    it "renders show template" do
      expect(response).to render_template :show
    end
    
    it "assigns the requested item to @item" do
      expect(assigns(:item)).to eq item
    end
  end

  describe "POST subscribe" do
    subject { post :subscribe, params: { id: item }, format: :json }

    shared_examples "guest" do
      it "returns status 401" do
        subject
        expect(response).to have_http_status 401
      end
    end

    shared_examples "authenticated" do
      it "returns json" do
        subject
        expect(JSON.parse(response.body)).to have_content I18n.t("items.subscribed")
      end

      it "assigns the requested item to @item" do
        subject
        expect(assigns(:item)).to eq item
      end

      it "creates a subscription" do
        expect{subject}.to change(Subscription, :count).by(1)
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