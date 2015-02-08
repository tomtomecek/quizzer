require "spec_helper"

describe Admin do
  it { is_expected.to have_secure_password }
  it { is_expected.to ensure_length_of(:password).is_at_least(6) }

  describe "#clear_token_and_expires_at!" do
    it "updates password reset to nil" do
      admin = Fabricate(:admin, password_reset_token: "token123")
      admin.clear_token_and_expires_at!
      expect(admin.password_reset_token).to be nil
    end

    it "updates password reset expires at to nil" do
      admin = Fabricate(:admin, password_reset_expires_at: 1.minute.from_now)
      admin.clear_token_and_expires_at!
      expect(admin.password_reset_expires_at).to be nil
    end
  end

  describe "#generate_password_reset_items" do
    it "updates password reset to a token" do
      admin = Fabricate(:admin, password_reset_token: nil)
      admin.generate_password_reset_items
      expect(admin.password_reset_token).to be_present
    end

    it "updates password reset expires at" do
      admin = Fabricate(:admin, password_reset_expires_at: nil)
      admin.generate_password_reset_items
      expect(admin.password_reset_expires_at).to be_present
    end
  end
end
