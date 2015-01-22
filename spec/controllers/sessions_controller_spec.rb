require 'spec_helper'

describe SessionsController do
  before { request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github] }

  describe "GET #create" do
    context "when no account" do
      it "creates an user account" do
        get :create, provider: "github"
        expect(User.count).to eq(1)
      end
    end

    context "when account exists" do
      it "does not create the user account" do
        Fabricate(:user, provider: "github", uid: "12345")
        get :create, provider: "github"
        expect(User.count).to eq(1)
      end
    end

    it "redirects to root url" do
      get :create, provider: "github"
      expect(response).to redirect_to root_url
    end

    it "sets the session :user_id" do
      get :create, provider: "github"
      user = User.first
      expect(session[:user_id]).to eq(user.id)
    end

    it "sets the flash success" do
      get :create, provider: "github"
      expect(flash[:success]).to be_present
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in
      delete :destroy
    end

    it { is_expected.to redirect_to root_url }
    it { is_expected.to set_session(:user_id).to nil }
    it { is_expected.to set_the_flash[:success] }
  end
end