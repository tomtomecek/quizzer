require 'spec_helper'

describe PasswordResetsController do
  describe "GET new" do
    it_behaves_like "require admin sign out" do
      let(:action) { get :new }
    end

    it_behaves_like "redirect users" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    let!(:admin) { Fabricate(:admin, email: "admin@example.com") }

    it_behaves_like "require admin sign out" do
      let(:action) { post :create, email: "admin@example.com" }
    end

    it_behaves_like "redirect users" do
      let(:action) { post :create, email: "stu@example.com" }
    end

    context "valid email" do
      let(:mail) { ActionMailer::Base.deliveries.last }
      let(:message) { mail.body.encoded }
      let(:token) { admin.reload.password_reset_token }
      let(:correct_link) do
        "<a href=\"http://localhost:52662/password_reset/#{token}\">"
      end
      before { post :create, email: "admin@example.com" }
      after { ActionMailer::Base.deliveries.clear }

      it { is_expected.to redirect_to confirm_password_reset_url }

      it "generates unique token" do
        expect(admin.reload.password_reset_token).to_not be nil
      end

      it "sends out the email" do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it "sends out an email to requested email address" do
        expect(mail.to).to eq(["admin@example.com"])
      end

      it "sends out an email with correct link" do
        expect(message).to include correct_link
        expect(message).to match /received.+request.+reset your password/m
      end

      it "sends out an email with correct subject" do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.subject).to eq("Reset Password - #{admin.email}")
      end
    end

    context "invalid email" do
      let!(:admin) { Fabricate(:admin, email: "admin@example.com") }
      before { post :create, email: "wrong@example.com" }

      it "does not generate password reset token" do
        expect(admin.reload.password_reset_token).to be nil
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET edit" do
    let(:admin) do
      Fabricate(:admin,
                email: "admin@example.com",
                password_reset_token: "token123",
                password_reset_expires_at: 2.hours.from_now)
    end

    it_behaves_like "require admin sign out" do
      let(:action) { get :edit, token: "some token" }
    end

    it_behaves_like "redirect users" do
      let(:action) { get :edit, token: "some token" }
    end

    context "with valid token" do
      it "sets the @admin" do
        get :edit, token: admin.password_reset_token
        expect(assigns(:admin)).to eq admin
      end
    end

    context "with invalid token" do
      before { Fabricate(:admin, password_reset_token: "token123") }

      it "redirects to root url with token" do
        get :edit, token: "wrong"
        expect(response).to redirect_to root_url
      end
    end

    context "with expired token" do
      it "redirects to expired token url" do
        Fabricate(:admin,
                  password_reset_token: "token123",
                  password_reset_expires_at: 1.hour.ago)
        get :edit, token: admin.password_reset_token
        expect(response).to redirect_to expired_token_url
      end
    end
  end

  describe "PATCH update" do
    it_behaves_like "require admin sign out" do
      let(:action) { patch :update, admin: { password: "new_password" } }
    end

    it_behaves_like "redirect users" do
      let(:action) { patch :update, admin: { password: "new_password" } }
    end

    context "with valid token" do
      let(:admin) do
        Fabricate(:admin,
                  email: "admin@example.com",
                  password: "old_password",
                  password_reset_token: "token123",
                  password_reset_expires_at: 2.hours.from_now)
      end

      before do
        patch :update,
              token: admin.password_reset_token,
              admin: { password: "new_password" }
      end

      it { is_expected.to redirect_to admin_sign_in_url }
      it { is_expected.to set_flash[:success] }

      it "updates to new password" do
        expect(admin.reload.authenticate("new_password")).to be admin
      end

      it "deletes the password reset token" do
        expect(admin.reload.password_reset_token).to be nil
      end

      it "deletes the expires at" do
        expect(admin.reload.password_reset_expires_at).to be nil
      end
    end

    context "with invalid token" do
      let!(:admin) do
        Fabricate(:admin,
                  email: "admin@example.com",
                  password: "old_password",
                  password_reset_token: "token123",
                  password_reset_expires_at: 2.hours.from_now)
      end

      before do
        patch :update,
              token: "invalid",
              admin: { password: "new_password" }
      end

      it { is_expected.to redirect_to root_url }
      it { is_expected.to set_flash[:danger] }

      it "does not update to new password" do
        expect(admin.reload.authenticate("new_password")).to be false
      end

      it "deletes the password reset token" do
        expect(admin.reload.password_reset_token).to_not be nil
      end

      it "deletes the expires at" do
        expect(admin.reload.password_reset_expires_at).to_not be nil
      end
    end

    context "with invalid password" do
      let!(:admin) do
        Fabricate(:admin,
                  email: "admin@example.com",
                  password: "old_password",
                  password_reset_token: "token123",
                  password_reset_expires_at: 2.hours.from_now)
      end

      before do
        patch :update,
              token: admin.password_reset_token,
              admin: { password: "123" }
      end

      it { is_expected.to render_template :edit }

      it "sets the @admin" do
        expect(assigns(:admin)).to eq admin
      end

      it "sets the errors on @admin" do
        expect(assigns(:admin).errors.any?).to be true
      end

      it "does not update to new password" do
        expect(admin.reload.authenticate("new_password")).to be false
      end

      it "deletes the password reset token" do
        expect(admin.reload.password_reset_token).to_not be nil
      end

      it "deletes the expires at" do
        expect(admin.reload.password_reset_expires_at).to_not be nil
      end
    end
  end
end
