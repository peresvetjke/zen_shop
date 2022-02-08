require "rails_helper"

RSpec.describe Admin::CategoriesController, :type => :controller do
  let!(:user)       { create(:user, type: "Admin") }
  let!(:categories) { create_list(:category, 5) }
  let(:category)    { categories.first }

    shared_examples "guest" do
      it "returns unauthorized status" do
        subject
        expect(response).to have_http_status 401
      end
    end  

    shared_examples "customer" do
      # it "redirects to root path" do
      #   subject
      #   expect(response).to redirect_to root_path
      # end
      it "returns forbidden status" do
        subject
        expect(response).to have_http_status 403
      end
    end

  describe "GET index" do
    subject { get :index }

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

  describe "PATCH update" do
    let(:params)  { { id: category, category: { title: "Title" }, format: :json } }

    subject { patch :update, params: params }

    shared_examples "admin" do
      it "assigns category" do 
        subject
        expect(assigns(:category)).to eq category
      end

      context "invalid params" do
        let(:params)  { { id: category, category: { title: "" }, format: :json } }

        it "does not update category in db" do
          subject
          expect(category.reload).to eq category
        end

        it "returns errors messages" do
          subject
          expect(response.body).to have_content 'errors'
        end
      end

      context "valid params" do
        it "updates category in db" do
          subject
          expect(category.reload.title).to eq "Title"
        end

        it "returns successful status" do
          subject
          expect(response).to be_successful
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
    let(:params)  { { category: { title: "Title" }, format: :json } }

    subject { post :create, params: params }

    shared_examples "admin" do
      context "invalid params" do
        let(:params)  { { category: { title: "" }, format: :json } }

        it "does not create a new category in db" do
          expect{subject}.not_to change(Category, :count)
        end

        it "returns errors messages" do
          subject
          expect(response.body).to have_content 'errors'
        end
      end

      context "valid params" do
        it "creates new category in db" do
          expect{subject}.to change(Category, :count).by(1)
        end

        it "returns successful status" do
          subject
          expect(response).to be_successful
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
    subject { delete :destroy, params: { id: category }, format: :json }

    shared_examples "admin" do
      it "assigns category" do 
        subject
        expect(assigns(:category)).to eq category
      end

      it "deletes category from db" do
        expect{subject}.to change(Category, :count).by(-1)
      end

      it "returns successful status" do
        subject
        expect(response).to be_successful
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