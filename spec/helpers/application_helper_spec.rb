require "spec_helper"

describe ApplicationHelper do

  describe "#github_sign_in_path" do
    context "when in production env" do
      it "returns /auth/github" do
        Rails.env.stub(:production?).and_return(true)
        expect(helper.github_sign_in_path).to eq "/auth/github"
      end
    end

    context "when not in production env" do
      it "returns /auth/developer" do
        Rails.env.stub(:production?).and_return(false)
        expect(helper.github_sign_in_path).to eq "/auth/developer"
      end
    end
  end
end
