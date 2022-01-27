require "rails_helper"

RSpec.describe Admin::CategoriesController, :type => :controller do
  let!(:user)       { create(:user, type: "Admin") }
  let!(:categories) { create_list(:category, 5) }
  let(:category)    { categories.first }

    shared_examples "guest" do
      it "redirects to sign_in path" do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end  

    shared_examples "customer" do
      it "redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end

  describe "GET index" do
    subject { get :index }

    shared_examples "admin" do
      before { subject }
      
      it { expect(response).to render_template :index }
      it { expect(assigns(:categories)).to match_array(categories) }
    end

    context "being a guest" do
      it_behaves_like "guest"
    end

    context "being a customer" do
      before { sign_in(create(:user, type: "Customer")) }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { sign_in(create(:user, type: "Admin")) }
      it_behaves_like "admin"
    end
  end

  describe "GET show" do
    subject { get :show, params: { id: category } }

    shared_examples "admin" do
      before { subject }
      
      it { expect(response).to render_template :show }
      it { expect(assigns(:category)).to eq category }
    end

    context "being a guest" do
      it_behaves_like "guest"
    end

    context "being a customer" do
      before { sign_in(create(:user, type: "Customer")) }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { sign_in(create(:user, type: "Admin")) }
      it_behaves_like "admin"
    end
  end

  describe "GET new" do
    subject { get :new }

    shared_examples "admin" do
      before { subject }
      
      it { expect(response).to render_template :new }
    end

    context "being a guest" do
      it_behaves_like "guest"
    end

    context "being a customer" do
      before { sign_in(create(:user, type: "Customer")) }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { sign_in(create(:user, type: "Admin")) }
      it_behaves_like "admin"
    end
  end

  describe "GET edit" do
    subject { get :edit, params: { id: category } }

    shared_examples "admin" do
      before { subject }
      
      it { expect(response).to render_template :edit }
      it { expect(assigns(:category)).to eq category }
    end

    context "being a guest" do
      it_behaves_like "guest"
    end

    context "being a customer" do
      before { sign_in(create(:user, type: "Customer")) }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { sign_in(create(:user, type: "Admin")) }
      it_behaves_like "admin"
    end
  end

  describe "PATCH update" do
    let(:params)  { { id: category, category: { title: "Title" } } }

    subject { patch :update, params: params }

    shared_examples "admin" do
      it "assigns category" do 
        subject
        expect(assigns(:category)).to eq category
      end

      context "invalid params" do
        let(:params)  { { id: category, category: { title: "" } } }

        it "does not update category in db" do
          subject
          expect(category.reload).to eq category
        end

        it "renders edit template" do
          subject
          expect(response).to render_template :edit
        end
      end

      context "valid params" do
        it "updates category in db" do
          subject
          expect(category.reload.title).to eq "Title"
        end

        it "redirects to updated category" do
          subject
          expect(response).to redirect_to admin_category_path(category)
        end
      end
    end

    context "being a guest" do
      it_behaves_like "guest"
    end

    context "being a customer" do
      before { sign_in(create(:user, type: "Customer")) }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { sign_in(create(:user, type: "Admin")) }
      it_behaves_like "admin"
    end
  end

  describe "POST create" do
    let(:params)  { { category: { title: "Title" } } }

    subject { post :create, params: params }

    shared_examples "admin" do
      context "invalid params" do
        let(:params)  { { category: { title: "" } } }

        it "does not create a new category in db" do
          expect{subject}.not_to change(Category, :count)
        end

        it "renders new template" do
          subject
          expect(response).to render_template :new
        end
      end

      context "valid params" do
        it "creates new category in db" do
          expect{subject}.to change(Category, :count).by(1)
        end

        it "redirects to new category" do
          subject
          expect(response).to redirect_to admin_category_path(Category.last)
        end
      end
    end

    context "being a guest" do
      it_behaves_like "guest"
    end

    context "being a customer" do
      before { sign_in(create(:user, type: "Customer")) }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { sign_in(create(:user, type: "Admin")) }
      it_behaves_like "admin"
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, params: { id: category } }

    shared_examples "admin" do
      it "assigns category" do 
        subject
        expect(assigns(:category)).to eq category
      end

      it "deletes category from db" do
        expect{subject}.to change(Category, :count).by(-1)
      end

      it "redirects to index" do
        subject
        expect(response).to redirect_to admin_categories_path
      end
      
    end

    context "being a guest" do
      it_behaves_like "guest"
    end

    context "being a customer" do
      before { sign_in(create(:user, type: "Customer")) }
      it_behaves_like "customer"
    end

    context "being an admin" do
      before { sign_in(create(:user, type: "Admin")) }
      it_behaves_like "admin"
    end
  end
end