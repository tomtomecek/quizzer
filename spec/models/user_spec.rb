require 'spec_helper'

describe User do
<<<<<<< HEAD
  it { is_expected.to have_many(:exams).with_foreign_key(:student_id) }

  describe ".from_omniauth" do
=======
  describe ".create_with_omniauth" do
    let(:auth) { OmniAuth.config.mock_auth[:github] }

    it "creates a user from omniauth hash" do
      User.create_with_omniauth(auth)
      expect(User.count).to eq(1)
    end
  end

  describe ".find_by_provider_and_uid" do
>>>>>>> master
    let(:auth) { OmniAuth.config.mock_auth[:github] }

    it "finds a user by provider and uid" do
      Fabricate(:user, provider: "github", uid: "12345")
      user = User.from_omniauth(auth)
      expect(User.first).to eq user
    end

    it "creates a user from omniauth hash" do
      User.from_omniauth(auth)
      expect(User.count).to eq(1)
    end
  end
end
