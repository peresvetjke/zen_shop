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
end