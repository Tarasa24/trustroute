require "rails_helper"

RSpec.describe KeysController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "when importing public key from file" do
      context "with valid public key file" do
        let(:public_key_file) { fixture_file_upload("keys/valid.pub.asc", "text/plain") }

        it "creates a new key from the file" do
          post :create, params: {public_key_file: public_key_file}

          expect(Key.count).to eq(1)
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to be_present
        end
      end

      context "with invalid public key file" do
        # Malformed public key file
        let(:public_key_file) { fixture_file_upload("keys/invalid.pub.asc", "text/plain") }

        it "does not create a new key from the file" do
          post :create, params: {public_key_file: public_key_file}

          expect(Key.count).to eq(0)
          expect(response).to redirect_to(new_key_path)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
