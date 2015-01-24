require "spec_helper"

describe Answer do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to validate_presence_of(:content) }

  describe "#incorrect?" do
    it "returns true if answer is falsy" do
      Fabricate(:answer, correct: false)
      expect(Answer.first).to be_incorrect
    end

    it "returns false if answer is truthy" do
      Fabricate(:answer, correct: true)
      expect(Answer.first).not_to be_incorrect
    end
  end
end
