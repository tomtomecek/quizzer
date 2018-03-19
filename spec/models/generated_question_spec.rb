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

  describe "#yield_points?" do
    let(:exam) { Fabricate(:exam) }
    let(:gquestion) { Fabricate(:gen_question, exam: exam) }
    let!(:a1) { Fabricate(:gen_correct, generated_question: gquestion) }
    let!(:a2) { Fabricate(:gen_incorrect, generated_question: gquestion) }
    let!(:a3) { Fabricate(:gen_correct, generated_question: gquestion) }
    let!(:a4) { Fabricate(:gen_correct, generated_question: gquestion) }

    it "returns true if question was correctly answered" do
      a1.update_column(:student_marked, true)
      a3.update_column(:student_marked, true)
      a4.update_column(:student_marked, true)
      expect(gquestion.yield_points?).to be true
    end

    it "returns false if question was not correctly answered" do
      a1.update_column(:student_marked, true)
      a2.update_column(:student_marked, true)
      expect(gquestion.yield_points?).to be false
    end
  end
end
