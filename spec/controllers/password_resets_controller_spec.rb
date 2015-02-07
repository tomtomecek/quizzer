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
    after { ActionMailer::Base.deliveries.clear }
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
      before { post :create, email: "admin@example.com" }

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
        token = admin.reload.password_reset_token
        expect(message).to include edit_password_reset_url(token)
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
end
