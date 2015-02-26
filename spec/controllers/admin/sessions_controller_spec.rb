require "spec_helper"

describe Admin::SessionsController do
  describe "GET new" do
    it "redirects to admin courses url for authenticated" do
      set_current_admin
      get :new
      expect(response).to redirect_to admin_courses_url
    end
  end

  describe "POST create" do
    context "activated" do
      context "with valid credentials" do
        let!(:admin) do
          Fabricate(:admin,
                    email: "admin@tealeaf.com",
                    password: "secret",
                    activated: true)
        end

        context "without remember me" do
          before do
            post :create,
                 email: "admin@tealeaf.com",
                 password: "secret",
                 remember_me: "0"
          end

          it { is_expected.to redirect_to admin_courses_url }
          it { is_expected.to set_session[:admin_id].to(admin.id) }
          it { is_expected.to set_flash[:success] }

          it "does not create remember digest" do
            expect(admin.reload.remember_digest).to be nil
          end
        end

        context "remember me selected" do
          before do
            post :create,
                 email: "admin@tealeaf.com",
                 password: "secret",
                 remember_me: '1'
          end

          it "creates remember digest" do
            expect(admin.reload.remember_digest).to_not be nil
          end

          it "sets cookies on remember token" do
            expect(cookies.permanent[:remember_token]).to be_instance_of(String)
          end

          it "sets signed cookies on admin id" do
            expect(cookies.permanent.signed[:admin_id]).to eq admin.id
          end
        end
      end

      context "with invalid credentials" do
        before { post :create, email: "no match", password: "secret" }

        it { is_expected.to render_template :new }
        it { is_expected.to set_flash.now[:danger] }
      end
    end

    context "not activated" do
      let!(:admin) do
        Fabricate(:admin,
                  email: "admin@tealeaf.com",
                  password: nil,
                  activated: false)
      end

      before do
        post :create,
             email: "admin@tealeaf.com",
             password: "secret",
             remember_me: "0"
      end

      it { is_expected.to render_template :new }
      it { is_expected.to set_flash.now[:info] }
      it { is_expected.to_not set_session[:admin_id] }
    end
  end

  describe "DELETE destroy" do
    let(:admin) { Fabricate(:admin) }
    it_behaves_like "require admin sign in" do
      let(:action) { delete :destroy }
    end

    context "with authenticated admin" do
      before do
        set_current_admin(admin)
        delete :destroy
      end

      it { is_expected.to redirect_to root_url }
      it { is_expected.to set_flash[:success] }
      it { is_expected.to_not set_session[:admin_id] }
    end

    context "with remember me cookies" do
      before do
        set_current_admin(admin, remember_me: true)
        delete :destroy
      end

      it "sets remember_digest to nil" do
        expect(admin.reload.remember_digest).to be nil
      end

      it "deletes cookies admin_id" do
        expect(cookies.signed[:admin_id]).to be nil
      end

      it "deletes cookies remember token" do
        expect(cookies[:remember_token]).to be nil
      end
    end
  end
end
