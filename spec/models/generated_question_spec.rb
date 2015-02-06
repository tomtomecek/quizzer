require 'spec_helper'

describe GeneratedQuestion do

  it { is_expected.to belong_to(:exam) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to have_db_index(:exam_id) }
  it { is_expected.to have_db_index(:question_id) }
  it { is_expected.to have_many(:generated_answers).dependent(:destroy) }

  describe "#build_answers!" do
    it "builds generated_answers" do
      question = Fabricate(:question)
      g_question = GeneratedQuestion.new(question: question)
      g_question.build_answers!
      expect(g_question.generated_answers).to_not be_empty
    end
  end
end
