require "spec_helper"

describe ApplicationHelper do
  describe "#github_sign_in_path" do
    it "returns /auth/github" do
      expect(helper.github_sign_in_path).to eq "/auth/github"
    end
  end
end
