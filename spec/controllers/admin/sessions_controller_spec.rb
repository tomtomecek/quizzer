require "spec_helper"

describe Admin::SessionsController do
  describe "POST create" do
    context "with valid credentials" do
      let!(:admin) do
        Fabricate(:admin, email: "admin@tealeaf.com", password: "secret")
      end
      before { post :create, email: "admin@tealeaf.com", password: "secret" }

      it { is_expected.to redirect_to admin_courses_url }
      it { is_expected.to set_session(:admin_id).to(admin.id) }
      it { is_expected.to set_the_flash[:success] }
    end

    context "with invalid credentials" do
      before { post :create, email: "no match", password: "secret" }

      it { is_expected.to render_template :new }
      it { is_expected.to set_the_flash.now[:danger] }
    end
  end

  describe "DELETE destroy" do
    let!(:admin) do
      Fabricate(:admin, email: "admin@tealeaf.com", password: "secret")
    end

    it_behaves_like "require admin sign in" do
      let(:action) { delete :destroy }
    end

    context "with authenticated admin" do
      before do
        set_current_admin(admin)
        delete :destroy
      end

      it { is_expected.to redirect_to root_url }
      it { is_expected.to set_the_flash[:success] }
      it { is_expected.to set_session(:admin_id).to(nil) }
    end
  end
end
