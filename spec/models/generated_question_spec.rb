require 'spec_helper'

describe GeneratedQuestion do

  it { is_expected.to belong_to(:exam) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to have_many(:generated_answers) }

  context "when built" do
    it "builds generated_answers" do
      g_question = GeneratedQuestion.new
      expect(g_question.generated_answers).to_not be_empty
    end
  end
end
