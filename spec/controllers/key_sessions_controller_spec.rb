require "rails_helper"

RSpec.describe KeySessionsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    let(:key) { create(:key) }

    it "redirects to root_path on success" do
      Key.any_instance.stub(:authenticate).and_return(true)
      post :create, params: {identifier: key.email, signed_challenge: "valid"}

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to be_present
    end

    it "redirects to new_key_session_path on failure" do
      Key.any_instance.stub(:authenticate).and_return(false)
      post :create, params: {identifier: key.email, signed_challenge: "invalid"}

      expect(response).to redirect_to(new_key_session_path)
      expect(flash[:alert]).to be_present
    end

    it "redirects to new_key_session_path on key not found" do
      post :create, params: {identifier: "invalid", signed_challenge: "invalid"}

      expect(response).to redirect_to(new_key_session_path)
      expect(flash[:alert]).to be_present
    end
  end
end
