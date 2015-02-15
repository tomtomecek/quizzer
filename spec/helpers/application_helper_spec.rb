require "spec_helper"

describe ApplicationHelper do
  describe "#github_sign_in_path" do
    it "returns /auth/github" do
      expect(helper.github_sign_in_path).to eq "/auth/github"
    end
  end

  describe "#passing_percentage_array" do
    it "returns an array" do
      expect(helper.passing_percentage_array).to be_instance_of Array
    end

    it "returns an array in an array" do
      expect(helper.passing_percentage_array.first).to be_instance_of Array
    end

    it "includes a number divisable by 5" do
      expect(helper.passing_percentage_array.sample[1]).to satisfy do |percent|
        percent % 5 == 0
      end
    end
  end
end
