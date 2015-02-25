require "spec_helper"

describe Admin do
  it { is_expected.to have_secure_password }
  it { is_expected.to ensure_length_of(:password).is_at_least(6) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to have_db_index(:email).unique(true) }

  it "allows nil for password" do
    admin = Fabricate(:admin, password: nil)
    expect(admin).to be_valid
  end

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

  describe "#remember" do
    it "updates remember_digest" do
      admin = Fabricate(:admin, remember_digest: nil)
      admin.remember
      expect(admin.remember_digest).to_not be nil
    end
  end

  describe "#forget!" do
    it "removes remember digest" do
      admin = Fabricate(:admin, remember_digest: "123")
      admin.forget!
      expect(admin.remember_digest).to be nil
    end
  end

  describe "#authenticated?(token)" do
    let(:admin) { Fabricate(:admin) }
    let(:token) { admin.remember_token }
    before { admin.remember }

    it "returns true if admin authenticates with token" do
      expect(admin).to be_authenticated(token)
    end

    it "returns false if admins authentication with token fails" do
      expect(admin.authenticated?("no match")).to be false
    end

    it "returns false if remember digest is nil" do
      admin.forget!
      expect(admin.authenticated?(token)).to be false
    end
  end

  describe "#instructor?" do
    it "returns true when admin is instructor" do
      kevin = Fabricate(:instructor, role: "instructor")
      expect(kevin).to be_instructor
    end

    it "returns false when admin is not instructor" do
      brandon = Fabricate(:instructor, role: "teaching assistant")
      expect(brandon).not_to be_instructor
    end
  end
end
