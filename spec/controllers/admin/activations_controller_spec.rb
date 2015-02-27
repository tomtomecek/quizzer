require 'spec_helper'

describe Admin::ActivationsController do
  describe "GET new" do
    let(:admin) { Fabricate(:admin, activation_token: "12345") }
    context "with valid token" do
      before { get :new, activation_token: admin.activation_token }

      it "sets the @admin" do
        expect(assigns(:admin)).to eq admin
      end
    end

    context "with invalid token" do
      before do
        Fabricate(:admin, activation_token: "12345")
        get :new, activation_token: "123"
      end

      it { is_expected.to redirect_to admin_sign_in_url }
    end
  end

  describe "POST create" do
    context "with valid token" do
      let(:admin) do
        Fabricate(:admin,
                  username: nil,
                  password: nil,
                  activation_token: "12345",
                  activated: false)
      end

      context "with valid data" do
        before do
          post :create,
               activation_token: admin.activation_token,
               admin: { username: "brandon", password: "password" }
        end

        it { is_expected.to redirect_to admin_courses_url }
        it { is_expected.to set_flash[:success] }
        it { is_expected.to set_session[:admin_id].to(admin.id) }

        it "sets the new password" do
          expect(admin.reload.password_digest).to_not be nil
        end

        it "activates the admin account" do
          expect(admin.reload).to be_activated
        end

        it "deletes the activation token" do
          expect(admin.reload.activation_token).to be nil
        end
      end

      context "with invalid data" do
        before do
          post :create,
               activation_token: admin.activation_token,
               admin: { username: "", password: "wrong" }
        end

        it { is_expected.to render_template :new }
        it { is_expected.to_not set_session[:admin_id] }
        it { is_expected.to set_flash.now[:danger] }

        it "sets the @admin" do
          expect(assigns(:admin)).to eq admin
        end

        it "does not update password" do
          expect(admin.reload.password_digest).to be nil
        end

        it "does not activate the admin account" do
          expect(admin.reload).to_not be_activated
        end

        it "deletes the activation token" do
          expect(admin.reload.activation_token).to_not be nil
        end
      end
    end

    context "with invalid token" do
      before do
        Fabricate(:admin, activation_token: "12345")
        post :create,
             activation_token: "123",
             admin: {
               username: "bash",
               password: "password"
             }
      end

      it { is_expected.to redirect_to admin_sign_in_url }
    end
  end
end
