require "spec_helper"

describe Admin::SessionsController do
  describe "POST create" do
    context "with valid credentials" do
      before { Fabricate(:admin, email: "ad@tealeaf.com", password: "secret") }

      it "redirets to admin courses url" do
        post :create, email: "ad@tealeaf.com", password: "secret"
        expect(response).to redirect_to admin_courses_url
      end

      it "sets the session" do
        admin = Admin.first
        post :create, email: "ad@tealeaf.com", password: "secret"
        expect(session[:admin_id]).to eq admin.id
      end

      it "sets the flash success" do
        post :create, email: "ad@tealeaf.com", password: "secret"
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid credentials" do
      it "renders the :new template" do
        post :create, email: "no match", password: "secret"
        expect(response).to render_template :new
      end

      it "sets flash danger" do
        post :create, email: "no match", password: "secret"
        expect(flash[:danger]).to be_present
      end
    end
  end
end
