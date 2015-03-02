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

  describe "#pretty_percentage" do
    it "returns 0% if no exams are passed" do
      enr = double('enrollment', completion_percentage: 0)
      expect(helper.pretty_percentage(enr.completion_percentage)).to eq "0%"
    end

    it "returns 50% when completion is 50" do
      enr = double('enrollment', completion_percentage: 50)
      expect(helper.pretty_percentage(enr.completion_percentage)).to eq "50%"
    end

    it "returns 100% when all exams are passed" do
      enr = double('enrollment', completion_percentage: 100)
      expect(helper.pretty_percentage(enr.completion_percentage)).to eq "100%"
    end

    context "display true" do
      it "returns completed if display option is given" do
        enr = double('enrollment', completion_percentage: 66)
        expect(helper.pretty_percentage(
          enr.completion_percentage,
          display: true
        )).to eq "66%"
      end

      it "returns completed if display option is given" do
        enr = double('enrollment', completion_percentage: 100)
        expect(helper.pretty_percentage(
          enr.completion_percentage,
          display: true
        )).to eq "Completed"
      end
    end
  end
end
